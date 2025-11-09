//
//  AuthenticationView.swift
//  ApexVisionAI
//

import SwiftUI
import AuthenticationServices

struct AuthenticationView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Background gradient using exact Chrome extension colors
            LinearGradient(
                colors: [
                    themeManager.primaryBlue,
                    themeManager.primaryBlueHover
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo and title
                VStack(spacing: 16) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                    
                    Text("ApexVision AI")
                        .font(themeManager.font(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Your AI-Powered Study Companion")
                        .font(themeManager.font(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Features
                VStack(spacing: 20) {
                    FeatureRow(icon: "message.fill", text: "AI-Powered Chat Assistant")
                    FeatureRow(icon: "camera.fill", text: "Image Analysis & OCR")
                    FeatureRow(icon: "brain.head.profile", text: "Exam Prediction")
                    FeatureRow(icon: "doc.text.fill", text: "Essay Writer")
                }
                .padding(.horizontal, 40)
                
                Spacer()

                // Sign in buttons
                VStack(spacing: 16) {
                    // Apple Sign-In Button
                    SignInWithAppleButton(
                        onRequest: { request in
                            let appleRequest = authManager.signInWithApple()
                            request.requestedScopes = appleRequest.requestedScopes
                            request.nonce = appleRequest.nonce
                        },
                        onCompletion: { result in
                            authManager.handleAppleSignInCompletion(result: result)
                        }
                    )
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .frame(height: 50)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

                    // Divider
                    HStack {
                        Rectangle()
                            .fill(Color.white.opacity(0.5))
                            .frame(height: 1)

                        Text("or")
                            .font(themeManager.font(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 8)

                        Rectangle()
                            .fill(Color.white.opacity(0.5))
                            .frame(height: 1)
                    }
                    .padding(.vertical, 8)

                    // Google Sign-In Button
                    GoogleSignInButton {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootVC = windowScene.windows.first?.rootViewController {
                            authManager.signInWithGoogle(presenting: rootVC)
                        }
                    }

                    if authManager.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }

                    if let error = authManager.errorMessage {
                        Text(error)
                            .font(themeManager.font(size: 12))
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 40)
            
            Text(text)
                .font(themeManager.font(size: 16))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

struct GoogleSignInButton: View {
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "g.circle.fill")
                    .font(.system(size: 24))

                Text("Sign in with Google")
                    .font(themeManager.font(size: 18, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.white)
            .foregroundColor(themeManager.primaryBlue)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationManager.shared)
        .environmentObject(ThemeManager.shared)
}

