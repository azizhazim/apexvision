//
//  AuthenticationManager.swift
//  ApexVisionAI
//
//  Handles user authentication with Google Sign-In, Apple Sign-In, and Firebase
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import AuthenticationServices
import CryptoKit
import Combine

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var userId: String?
    @Published var userEmail: String?
    @Published var userName: String?
    @Published var subscriptionLevel: String = "No subscription"
    @Published var requestCount: Int = 0
    @Published var freeRequestsRemaining: Int = 10
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()

    // For Apple Sign-In
    private var currentNonce: String?

    private init() {
        checkAuthenticationStatus()
    }
    
    // MARK: - Authentication Status
    
    func checkAuthenticationStatus() {
        if let currentUser = Auth.auth().currentUser {
            self.isAuthenticated = true
            self.userId = currentUser.uid
            self.userEmail = currentUser.email
            self.userName = currentUser.displayName
            fetchUserData()
        } else {
            self.isAuthenticated = false
        }
    }
    
    // MARK: - Google Sign-In
    
    func signInWithGoogle(presenting viewController: UIViewController) {
        isLoading = true
        errorMessage = nil
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Failed to get client ID"
            isLoading = false
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self.errorMessage = "Failed to get user data"
                self.isLoading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                          accessToken: user.accessToken.tokenString)
            
            // Sign in to Firebase
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    return
                }
                
                // Send token to backend
                self.sendTokenToBackend(idToken: idToken)
            }
        }
    }
    
    // MARK: - Apple Sign-In

    func signInWithApple() -> ASAuthorizationAppleIDRequest {
        let nonce = randomNonceString()
        currentNonce = nonce

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        return request
    }

    func handleAppleSignInCompletion(result: Result<ASAuthorization, Error>) {
        isLoading = true
        errorMessage = nil

        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    errorMessage = "Invalid state: A login callback was received, but no login request was sent."
                    isLoading = false
                    return
                }

                guard let appleIDToken = appleIDCredential.identityToken else {
                    errorMessage = "Unable to fetch identity token"
                    isLoading = false
                    return
                }

                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    errorMessage = "Unable to serialize token string from data"
                    isLoading = false
                    return
                }

                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)

                // Sign in to Firebase
                Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                    guard let self = self else { return }

                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                        return
                    }

                    // Get user info
                    if let user = authResult?.user {
                        self.userId = user.uid
                        self.userEmail = user.email ?? appleIDCredential.email

                        // Construct name from Apple ID credential if available
                        if let fullName = appleIDCredential.fullName {
                            let firstName = fullName.givenName ?? ""
                            let lastName = fullName.familyName ?? ""
                            self.userName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
                        }

                        // Send to backend for account linking
                        self.sendAppleAuthToBackend(idToken: idTokenString,
                                                   email: self.userEmail ?? "",
                                                   name: self.userName ?? "")
                    }
                }
            }

        case .failure(let error):
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    // MARK: - Backend Integration

    private func sendTokenToBackend(idToken: String) {
        let url = URL(string: "https://api.apexvision.ai/google_login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["id_token": idToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let userId = json["user_id"] as? String {
                            self?.userId = userId
                            self?.isAuthenticated = true
                            self?.fetchUserData()
                        }
                    }
                } catch {
                    self?.errorMessage = "Failed to parse response"
                }
            }
        }.resume()
    }

    private func sendAppleAuthToBackend(idToken: String, email: String, name: String) {
        // For Apple Sign-In, we'll use the same backend endpoint
        // The backend should handle both Google and Apple authentication
        let url = URL(string: "https://api.apexvision.ai/google_login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "id_token": idToken,
            "provider": "apple",
            "email": email,
            "name": name
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let userId = json["user_id"] as? String {
                            self?.userId = userId
                            self?.isAuthenticated = true
                            self?.fetchUserData()
                        }
                    }
                } catch {
                    self?.errorMessage = "Failed to parse response"
                }
            }
        }.resume()
    }
    
    // MARK: - User Data
    
    func fetchUserData() {
        guard let userId = userId else { return }
        
        db.collection("tokens").document(userId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else { return }
            
            DispatchQueue.main.async {
                self.subscriptionLevel = data["subscription_level"] as? String ?? "No subscription"
                self.requestCount = data["request_count"] as? Int ?? 0
                self.freeRequestsRemaining = data["free_requests_remaining"] as? Int ?? 10
                self.userEmail = data["email"] as? String
                self.userName = data["name"] as? String
            }
        }
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            
            isAuthenticated = false
            currentUser = nil
            userId = nil
            userEmail = nil
            userName = nil
            subscriptionLevel = "No subscription"
            requestCount = 0
            freeRequestsRemaining = 10
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Subscription Check
    
    func isMastermindSubscriber() -> Bool {
        let level = subscriptionLevel.uppercased()
        return level == "MASTERMIND" || level.hasPrefix("CUSTOM_MASTERMIND")
    }
    
    func canMakeRequest() -> Bool {
        // Check subscription limits (matching backend logic)
        let limits: [String: Int] = [
            "MASTERMIND": 2000,
            "SAVVY SCHOLAR": 1000,
            "KNOWLEDGE KICKSTART": 500,
            "No subscription": 15,
            "cancelled": 0
        ]

        let baseLevel = subscriptionLevel.replacingOccurrences(of: "Custom_", with: "").components(separatedBy: "_")[0]
        let limit = limits[baseLevel] ?? 15

        return requestCount < limit || freeRequestsRemaining > 0
    }

    // MARK: - Apple Sign-In Helpers

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}

