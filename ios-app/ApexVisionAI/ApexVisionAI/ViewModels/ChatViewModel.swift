//
//  ChatViewModel.swift
//  ApexVisionAI
//
//  View model for chat functionality
//

import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var currentSession: ChatSession
    @Published var sessions: [ChatSession] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkManager = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.currentSession = ChatSession()
        loadSessions()
    }
    
    // MARK: - Send Message
    
    func sendMessage(_ text: String, userId: String) async {
        // Add user message
        let userMessage = ChatMessage(text: text, isUser: true)
        currentSession.messages.append(userMessage)
        currentSession.updatedAt = Date()
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Get AI response
            let response = try await networkManager.getAIResponse(userInput: text, userId: userId)
            
            if response.status == "success", let aiText = response.response {
                let aiMessage = ChatMessage(text: aiText, isUser: false)
                currentSession.messages.append(aiMessage)
                currentSession.updatedAt = Date()
                
                // Save session
                saveCurrentSession()
            } else if let error = response.error {
                errorMessage = error
                let errorMsg = ChatMessage(text: "Error: \(error)", isUser: false)
                currentSession.messages.append(errorMsg)
            }
        } catch {
            errorMessage = error.localizedDescription
            let errorMsg = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
            currentSession.messages.append(errorMsg)
        }
        
        isLoading = false
    }
    
    // MARK: - Session Management
    
    func startNewSession() {
        if !currentSession.messages.isEmpty {
            saveCurrentSession()
        }
        currentSession = ChatSession()
    }
    
    func loadSession(_ session: ChatSession) {
        if !currentSession.messages.isEmpty {
            saveCurrentSession()
        }
        currentSession = session
    }
    
    func deleteSession(_ session: ChatSession) {
        sessions.removeAll { $0.id == session.id }
        saveSessions()
        
        if currentSession.id == session.id {
            currentSession = ChatSession()
        }
    }
    
    private func saveCurrentSession() {
        if let index = sessions.firstIndex(where: { $0.id == currentSession.id }) {
            sessions[index] = currentSession
        } else {
            sessions.insert(currentSession, at: 0)
        }
        saveSessions()
    }
    
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: "chatSessions")
        }
    }
    
    private func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: "chatSessions"),
           let decoded = try? JSONDecoder().decode([ChatSession].self, from: data) {
            sessions = decoded
        }
    }
    
    // MARK: - Clear History
    
    func clearAllSessions() {
        sessions.removeAll()
        currentSession = ChatSession()
        saveSessions()
    }
}

