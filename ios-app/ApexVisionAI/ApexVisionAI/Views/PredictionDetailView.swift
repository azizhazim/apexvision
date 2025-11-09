//
//  PredictionDetailView.swift
//  ApexVisionAI
//

import SwiftUI

struct PredictionDetailView: View {
    let prediction: ExamPrediction
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var answer: String?
    @State private var isLoadingAnswer = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Question
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Question")
                                .font(themeManager.font(size: 18, weight: .bold))
                            Spacer()
                            DifficultyBadge(difficulty: prediction.difficulty)
                        }
                        
                        Text(prediction.question)
                            .font(themeManager.font(size: 16))
                            .padding()
                            .background(themeManager.cardBackgroundColor)
                            .cornerRadius(12)
                    }
                    
                    // Topic
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Topic")
                            .font(themeManager.font(size: 16, weight: .semibold))
                        
                        HStack {
                            Image(systemName: "tag.fill")
                            Text(prediction.topic)
                        }
                        .font(themeManager.font(size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                    }
                    
                    // Reasoning
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Why This Question?")
                            .font(themeManager.font(size: 16, weight: .semibold))
                        
                        Text(prediction.reasoning)
                            .font(themeManager.font(size: 14))
                            .padding()
                            .background(themeManager.cardBackgroundColor)
                            .cornerRadius(12)
                    }
                    
                    // Study Tips
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Study Tips")
                            .font(themeManager.font(size: 16, weight: .semibold))
                        
                        Text(prediction.studyTips)
                            .font(themeManager.font(size: 14))
                            .padding()
                            .background(themeManager.cardBackgroundColor)
                            .cornerRadius(12)
                    }
                    
                    // Get Answer button
                    if answer == nil {
                        Button(action: loadAnswer) {
                            HStack {
                                if isLoadingAnswer {
                                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    Text("Loading...")
                                } else {
                                    Image(systemName: "lightbulb.fill")
                                    Text("Show Answer & Explanation")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(isLoadingAnswer)
                    }
                    
                    // Answer
                    if let answer = answer {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Answer & Explanation")
                                .font(themeManager.font(size: 16, weight: .semibold))
                            
                            Text(answer)
                                .font(themeManager.font(size: 14))
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .background(themeManager.backgroundColor)
            .navigationTitle("Question Details")
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
    
    private func loadAnswer() {
        isLoadingAnswer = true
        Task {
            do {
                let response = try await networkManager.generateExamAnswer(
                    question: prediction.question,
                    topic: prediction.topic,
                    userId: authManager.userId ?? ""
                )
                answer = response.answer
            } catch {
                answer = "Error loading answer: \(error.localizedDescription)"
            }
            isLoadingAnswer = false
        }
    }
}

