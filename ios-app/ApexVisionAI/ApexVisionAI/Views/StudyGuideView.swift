//
//  StudyGuideView.swift
//  ApexVisionAI
//

import SwiftUI

struct StudyGuideView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var topic = ""
    @State private var studyGuide: String?
    @State private var isGenerating = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 60))
                        .foregroundColor(themeManager.primaryColor)
                    
                    Text("Study Guide Generator")
                        .font(themeManager.font(size: 24, weight: .bold))
                    
                    TextField("Enter topic or paste notes", text: $topic, axis: .vertical)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(themeManager.cardBackgroundColor)
                        .cornerRadius(12)
                        .lineLimit(5...15)
                    
                    Button(action: generateGuide) {
                        HStack {
                            if isGenerating {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                                Text("Generating...")
                            } else {
                                Image(systemName: "sparkles")
                                Text("Generate Study Guide")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(topic.isEmpty ? Color.gray : themeManager.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(topic.isEmpty || isGenerating)
                    
                    if let guide = studyGuide {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Study Guide")
                                .font(themeManager.font(size: 18, weight: .semibold))
                            
                            Text(guide)
                                .font(themeManager.font(size: 15))
                                .padding()
                                .background(themeManager.cardBackgroundColor)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .background(themeManager.backgroundColor)
            .navigationTitle("Study Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                }
            }
        }
    }
    
    private func generateGuide() {
        isGenerating = true
        Task {
            do {
                let response = try await networkManager.generateStudyGuide(conversation: topic, userId: authManager.userId ?? "")
                studyGuide = response.studyGuide
                authManager.fetchUserData()
            } catch {
                studyGuide = "Error: \(error.localizedDescription)"
            }
            isGenerating = false
        }
    }
}

