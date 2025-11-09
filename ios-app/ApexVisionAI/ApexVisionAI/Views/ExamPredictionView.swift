//
//  ExamPredictionView.swift
//  ApexVisionAI
//
//  Exam question prediction feature
//

import SwiftUI
import UniformTypeIdentifiers

struct ExamPredictionView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var courseName = ""
    @State private var professorName = ""
    @State private var uploadedFiles: [UploadedFile] = []
    @State private var predictions: [ExamPrediction] = []
    @State private var isAnalyzing = false
    @State private var showingFilePicker = false
    @State private var usageInfo: ExamLimitResponse?
    @State private var selectedPrediction: ExamPrediction?
    @State private var showingAnswer = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView
                    
                    // Usage counter
                    if let usage = usageInfo {
                        usageView(usage: usage)
                    }
                    
                    // Input form
                    if predictions.isEmpty {
                        inputFormView
                    }
                    
                    // Predictions
                    if !predictions.isEmpty {
                        predictionsView
                    }
                }
                .padding()
            }
            .background(themeManager.backgroundColor)
            .navigationTitle("Exam Prediction")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadUsageInfo)
            .sheet(isPresented: $showingFilePicker) {
                DocumentPicker(files: $uploadedFiles)
            }
            .sheet(item: $selectedPrediction) { prediction in
                PredictionDetailView(prediction: prediction)
            }
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(themeManager.primaryColor)
            
            Text("Exam Prediction")
                .font(themeManager.font(size: 24, weight: .bold))
                .foregroundColor(themeManager.textColor)
            
            Text("Upload course materials to predict exam questions")
                .font(themeManager.font(size: 14))
                .foregroundColor(themeManager.secondaryTextColor)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    // MARK: - Usage View
    
    private func usageView(usage: ExamLimitResponse) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Usage")
                    .font(themeManager.font(size: 12))
                    .foregroundColor(themeManager.secondaryTextColor)
                
                Text("\(usage.used) / \(usage.limit)")
                    .font(themeManager.font(size: 18, weight: .bold))
                    .foregroundColor(themeManager.primaryColor)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Remaining")
                    .font(themeManager.font(size: 12))
                    .foregroundColor(themeManager.secondaryTextColor)
                
                Text("\(usage.remaining)")
                    .font(themeManager.font(size: 18, weight: .bold))
                    .foregroundColor(usage.remaining > 0 ? .green : .red)
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
    }
    
    // MARK: - Input Form
    
    private var inputFormView: some View {
        VStack(spacing: 16) {
            // Course name
            VStack(alignment: .leading, spacing: 8) {
                Text("Course Name")
                    .font(themeManager.font(size: 14, weight: .medium))
                    .foregroundColor(themeManager.textColor)
                
                TextField("e.g., Biology 101", text: $courseName)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(8)
            }
            
            // Professor name
            VStack(alignment: .leading, spacing: 8) {
                Text("Professor Name")
                    .font(themeManager.font(size: 14, weight: .medium))
                    .foregroundColor(themeManager.textColor)
                
                TextField("e.g., Dr. Smith", text: $professorName)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(8)
            }
            
            // Files
            VStack(alignment: .leading, spacing: 8) {
                Text("Course Materials")
                    .font(themeManager.font(size: 14, weight: .medium))
                    .foregroundColor(themeManager.textColor)
                
                Button(action: { showingFilePicker = true }) {
                    HStack {
                        Image(systemName: "doc.badge.plus")
                        Text("Upload Files")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.secondaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                // Uploaded files list
                ForEach(uploadedFiles) { file in
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(themeManager.primaryColor)
                        Text(file.name)
                            .font(themeManager.font(size: 14))
                            .foregroundColor(themeManager.textColor)
                        Spacer()
                        Button(action: { removeFile(file) }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(8)
                }
            }
            
            // Analyze button
            Button(action: analyzeMaterials) {
                HStack {
                    if isAnalyzing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        Text("Analyzing...")
                    } else {
                        Image(systemName: "sparkles")
                        Text("Predict Questions")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(canAnalyze ? themeManager.primaryColor : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(!canAnalyze || isAnalyzing)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
    }
    
    // MARK: - Predictions View
    
    private var predictionsView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Predicted Questions")
                    .font(themeManager.font(size: 20, weight: .bold))
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                Button(action: resetForm) {
                    Text("New Prediction")
                        .font(themeManager.font(size: 14))
                        .foregroundColor(themeManager.primaryColor)
                }
            }
            
            ForEach(Array(predictions.enumerated()), id: \.element.id) { index, prediction in
                PredictionCard(prediction: prediction, index: index + 1)
                    .onTapGesture {
                        selectedPrediction = prediction
                    }
            }
        }
    }
    
    // MARK: - Helpers
    
    private var canAnalyze: Bool {
        !courseName.isEmpty && !professorName.isEmpty && !uploadedFiles.isEmpty
    }
    
    private func removeFile(_ file: UploadedFile) {
        uploadedFiles.removeAll { $0.id == file.id }
    }
    
    private func resetForm() {
        courseName = ""
        professorName = ""
        uploadedFiles = []
        predictions = []
    }
    
    private func loadUsageInfo() {
        Task {
            do {
                usageInfo = try await networkManager.checkExamLimit(userId: authManager.userId ?? "")
            } catch {
                print("Error loading usage info: \(error)")
            }
        }
    }
    
    private func analyzeMaterials() {
        isAnalyzing = true
        
        let materials = uploadedFiles.map { file in
            ["name": file.name, "content": file.content]
        }
        
        Task {
            do {
                let response = try await networkManager.predictExamQuestions(
                    courseName: courseName,
                    professorName: professorName,
                    materials: materials,
                    userId: authManager.userId ?? ""
                )
                
                predictions = response.predictions
                loadUsageInfo()
            } catch {
                print("Error: \(error)")
            }
            
            isAnalyzing = false
        }
    }
}

// MARK: - Prediction Card

struct PredictionCard: View {
    let prediction: ExamPrediction
    let index: Int
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Question \(index)")
                    .font(themeManager.font(size: 16, weight: .bold))
                    .foregroundColor(themeManager.primaryColor)
                
                Spacer()
                
                DifficultyBadge(difficulty: prediction.difficulty)
            }
            
            Text(prediction.question)
                .font(themeManager.font(size: 15))
                .foregroundColor(themeManager.textColor)
            
            HStack {
                Label(prediction.topic, systemImage: "tag.fill")
                    .font(themeManager.font(size: 12))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Supporting Types

struct UploadedFile: Identifiable {
    let id = UUID()
    let name: String
    let content: String
}

struct DifficultyBadge: View {
    let difficulty: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var color: Color {
        switch difficulty.lowercased() {
        case "easy": return .green
        case "medium": return .orange
        case "hard": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        Text(difficulty)
            .font(themeManager.font(size: 12, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(12)
    }
}

#Preview {
    ExamPredictionView()
        .environmentObject(AuthenticationManager.shared)
        .environmentObject(NetworkManager.shared)
        .environmentObject(ThemeManager.shared)
}

