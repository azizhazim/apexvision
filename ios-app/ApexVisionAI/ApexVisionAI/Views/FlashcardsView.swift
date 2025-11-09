//
//  FlashcardsView.swift
//  ApexVisionAI
//
//  Flashcard generation and study feature
//

import SwiftUI

struct FlashcardsView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var topic = ""
    @State private var flashcards: [Flashcard] = []
    @State private var isGenerating = false
    @State private var currentCardIndex = 0
    @State private var isFlipped = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if flashcards.isEmpty {
                    inputView
                } else {
                    studyView
                }
            }
            .padding()
            .background(themeManager.backgroundColor)
            .navigationTitle("Flashcards")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Input View
    
    private var inputView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "rectangle.stack.fill")
                .font(.system(size: 60))
                .foregroundColor(themeManager.primaryColor)
            
            Text("Generate Flashcards")
                .font(themeManager.font(size: 24, weight: .bold))
                .foregroundColor(themeManager.textColor)
            
            Text("Enter a topic to create study flashcards")
                .font(themeManager.font(size: 14))
                .foregroundColor(themeManager.secondaryTextColor)
                .multilineTextAlignment(.center)
            
            TextField("Enter topic (e.g., World War II)", text: $topic, axis: .vertical)
                .textFieldStyle(.plain)
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(12)
                .lineLimit(2...4)
            
            Button(action: generateFlashcards) {
                HStack {
                    if isGenerating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        Text("Generating...")
                    } else {
                        Image(systemName: "sparkles")
                        Text("Generate Flashcards")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(topic.isEmpty ? Color.gray : themeManager.primaryColor)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(topic.isEmpty || isGenerating)
            
            Spacer()
        }
    }
    
    // MARK: - Study View
    
    private var studyView: some View {
        VStack(spacing: 24) {
            // Progress
            HStack {
                Text("\(currentCardIndex + 1) / \(flashcards.count)")
                    .font(themeManager.font(size: 16, weight: .semibold))
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                Button(action: resetFlashcards) {
                    Text("New Topic")
                        .font(themeManager.font(size: 14))
                        .foregroundColor(themeManager.primaryColor)
                }
            }
            
            ProgressView(value: Double(currentCardIndex + 1), total: Double(flashcards.count))
                .tint(themeManager.primaryColor)
            
            Spacer()
            
            // Flashcard
            FlashcardView(
                card: flashcards[currentCardIndex],
                isFlipped: $isFlipped
            )
            .frame(height: 400)
            
            Spacer()
            
            // Navigation buttons
            HStack(spacing: 16) {
                Button(action: previousCard) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(currentCardIndex > 0 ? themeManager.primaryColor : .gray)
                }
                .disabled(currentCardIndex == 0)
                
                Spacer()
                
                Button(action: { isFlipped.toggle() }) {
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(themeManager.secondaryColor)
                }
                
                Spacer()
                
                Button(action: nextCard) {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(currentCardIndex < flashcards.count - 1 ? themeManager.primaryColor : .gray)
                }
                .disabled(currentCardIndex >= flashcards.count - 1)
            }
        }
    }
    
    // MARK: - Actions
    
    private func generateFlashcards() {
        isGenerating = true
        
        Task {
            do {
                let response = try await networkManager.generateFlashcards(
                    topic: topic,
                    userId: authManager.userId ?? ""
                )
                
                // Parse JSON response
                if let data = response.flashcards.data(using: .utf8),
                   let cards = try? JSONDecoder().decode([Flashcard].self, from: data) {
                    flashcards = cards
                }
                
                authManager.fetchUserData()
            } catch {
                print("Error: \(error)")
            }
            
            isGenerating = false
        }
    }
    
    private func nextCard() {
        if currentCardIndex < flashcards.count - 1 {
            withAnimation {
                currentCardIndex += 1
                isFlipped = false
            }
        }
    }
    
    private func previousCard() {
        if currentCardIndex > 0 {
            withAnimation {
                currentCardIndex -= 1
                isFlipped = false
            }
        }
    }
    
    private func resetFlashcards() {
        flashcards = []
        currentCardIndex = 0
        isFlipped = false
        topic = ""
    }
}

// MARK: - Flashcard View

struct FlashcardView: View {
    let card: Flashcard
    @Binding var isFlipped: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            // Back (Answer)
            CardSide(text: card.back, label: "Answer")
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : 180), axis: (x: 0, y: 1, z: 0))
            
            // Front (Question)
            CardSide(text: card.front, label: "Question")
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isFlipped.toggle()
            }
        }
    }
}

struct CardSide: View {
    let text: String
    let label: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            Text(label)
                .font(themeManager.font(size: 14, weight: .semibold))
                .foregroundColor(themeManager.primaryColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(themeManager.primaryColor.opacity(0.2))
                .cornerRadius(12)
            
            Spacer()
            
            Text(text)
                .font(themeManager.font(size: 18))
                .foregroundColor(themeManager.textColor)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            Text("Tap to flip")
                .font(themeManager.font(size: 12))
                .foregroundColor(themeManager.secondaryTextColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    FlashcardsView()
        .environmentObject(AuthenticationManager.shared)
        .environmentObject(NetworkManager.shared)
        .environmentObject(ThemeManager.shared)
}

