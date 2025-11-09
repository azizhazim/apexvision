//
//  MathSolverView.swift
//  ApexVisionAI
//

import SwiftUI

struct MathSolverView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var question = ""
    @State private var solution: String?
    @State private var isSolving = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "function")
                        .font(.system(size: 60))
                        .foregroundColor(themeManager.primaryColor)
                    
                    Text("Math Solver")
                        .font(themeManager.font(size: 24, weight: .bold))
                    
                    TextField("Enter your math problem", text: $question, axis: .vertical)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(themeManager.cardBackgroundColor)
                        .cornerRadius(12)
                        .lineLimit(3...10)
                    
                    Button(action: solveMath) {
                        HStack {
                            if isSolving {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                                Text("Solving...")
                            } else {
                                Image(systemName: "sparkles")
                                Text("Solve")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(question.isEmpty ? Color.gray : themeManager.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(question.isEmpty || isSolving)
                    
                    if let solution = solution {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Solution")
                                .font(themeManager.font(size: 18, weight: .semibold))
                            
                            Text(solution)
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
            .navigationTitle("Math Solver")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                }
            }
        }
    }
    
    private func solveMath() {
        isSolving = true
        Task {
            do {
                let response = try await networkManager.solveMath(question: question, userId: authManager.userId ?? "")
                solution = response.solution
                authManager.fetchUserData()
            } catch {
                solution = "Error: \(error.localizedDescription)"
            }
            isSolving = false
        }
    }
}

