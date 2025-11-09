//
//  CodeHelperView.swift
//  ApexVisionAI
//

import SwiftUI

struct CodeHelperView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var prompt = ""
    @State private var solution: String?
    @State private var isGenerating = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "chevron.left.forwardslash.chevron.right")
                        .font(.system(size: 60))
                        .foregroundColor(themeManager.primaryColor)
                    
                    Text("Code Helper")
                        .font(themeManager.font(size: 24, weight: .bold))
                    
                    TextField("Describe what you need help with", text: $prompt, axis: .vertical)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(themeManager.cardBackgroundColor)
                        .cornerRadius(12)
                        .lineLimit(3...10)
                    
                    Button(action: getCodeHelp) {
                        HStack {
                            if isGenerating {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                                Text("Generating...")
                            } else {
                                Image(systemName: "sparkles")
                                Text("Get Help")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(prompt.isEmpty ? Color.gray : themeManager.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(prompt.isEmpty || isGenerating)
                    
                    if let solution = solution {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Solution")
                                    .font(themeManager.font(size: 18, weight: .semibold))
                                Spacer()
                                Button(action: { UIPasteboard.general.string = solution }) {
                                    Image(systemName: "doc.on.doc")
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: true) {
                                Text(solution)
                                    .font(.system(size: 14, design: .monospaced))
                                    .padding()
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(themeManager.backgroundColor)
            .navigationTitle("Code Helper")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                }
            }
        }
    }
    
    private func getCodeHelp() {
        isGenerating = true
        Task {
            do {
                let response = try await networkManager.getCodeHelp(prompt: prompt, userId: authManager.userId ?? "")
                solution = response.solution
                authManager.fetchUserData()
            } catch {
                solution = "Error: \(error.localizedDescription)"
            }
            isGenerating = false
        }
    }
}

