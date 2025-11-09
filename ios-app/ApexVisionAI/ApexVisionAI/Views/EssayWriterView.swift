//
//  EssayWriterView.swift
//  ApexVisionAI
//
//  Essay generation feature
//

import SwiftUI
import PDFKit

struct EssayWriterView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var settings = EssaySettings()
    @State private var isGenerating = false
    @State private var generatedPDF: Data?
    @State private var essayTitle: String?
    @State private var showingPDF = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView
                    
                    // Settings form
                    settingsFormView
                    
                    // Generate button
                    generateButton
                    
                    // Result
                    if generatedPDF != nil {
                        resultView
                    }
                }
                .padding()
            }
            .background(themeManager.backgroundColor)
            .navigationTitle("Essay Writer")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingPDF) {
                if let pdfData = generatedPDF {
                    PDFViewerView(pdfData: pdfData, title: essayTitle ?? "Essay")
                }
            }
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 60))
                .foregroundColor(themeManager.primaryColor)
            
            Text("Essay Writer")
                .font(themeManager.font(size: 24, weight: .bold))
                .foregroundColor(themeManager.textColor)
            
            Text("Generate professional essays with citations")
                .font(themeManager.font(size: 14))
                .foregroundColor(themeManager.secondaryTextColor)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    // MARK: - Settings Form
    
    private var settingsFormView: some View {
        VStack(spacing: 16) {
            // Topic
            FormField(title: "Essay Topic", placeholder: "Enter your essay topic") {
                TextField("", text: $settings.topic, axis: .vertical)
                    .lineLimit(3...6)
            }
            
            // Word Count
            FormField(title: "Word Count: \(settings.wordCount)") {
                Slider(value: Binding(
                    get: { Double(settings.wordCount) },
                    set: { settings.wordCount = Int($0) }
                ), in: 250...5000, step: 250)
                .tint(themeManager.primaryColor)
            }
            
            // Essay Type
            FormField(title: "Essay Type") {
                Picker("", selection: $settings.essayType) {
                    ForEach(["Argumentative", "Expository", "Narrative", "Descriptive", "Persuasive"], id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                .pickerStyle(.menu)
            }
            
            // Academic Level
            FormField(title: "Academic Level") {
                Picker("", selection: $settings.academicLevel) {
                    ForEach(["High School", "Undergraduate", "Graduate", "PhD"], id: \.self) { level in
                        Text(level).tag(level)
                    }
                }
                .pickerStyle(.menu)
            }
            
            // Citation Style
            FormField(title: "Citation Style") {
                Picker("", selection: $settings.citationStyle) {
                    ForEach(["MLA", "APA", "Chicago", "Harvard"], id: \.self) { style in
                        Text(style).tag(style)
                    }
                }
                .pickerStyle(.menu)
            }
            
            // Tone
            FormField(title: "Tone") {
                Picker("", selection: $settings.tone) {
                    ForEach(["Formal", "Semi-formal", "Casual", "Academic"], id: \.self) { tone in
                        Text(tone).tag(tone)
                    }
                }
                .pickerStyle(.menu)
            }
            
            // Toggles
            Toggle("Include Citations", isOn: $settings.includeCitations)
                .tint(themeManager.primaryColor)
            
            Toggle("Include Outline", isOn: $settings.includeOutline)
                .tint(themeManager.primaryColor)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
    }
    
    // MARK: - Generate Button
    
    private var generateButton: some View {
        Button(action: generateEssay) {
            HStack {
                if isGenerating {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Text("Generating...")
                } else {
                    Image(systemName: "sparkles")
                    Text("Generate Essay")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(settings.topic.isEmpty ? Color.gray : themeManager.primaryColor)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(settings.topic.isEmpty || isGenerating)
    }
    
    // MARK: - Result View
    
    private var resultView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Essay Generated!")
                        .font(themeManager.font(size: 18, weight: .bold))
                        .foregroundColor(themeManager.textColor)
                    
                    if let title = essayTitle {
                        Text(title)
                            .font(themeManager.font(size: 14))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                }
                
                Spacer()
            }
            
            Button(action: { showingPDF = true }) {
                HStack {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("View PDF")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(themeManager.primaryColor)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            Button(action: sharePDF) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share PDF")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(themeManager.secondaryColor)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Actions
    
    private func generateEssay() {
        isGenerating = true
        
        Task {
            do {
                let response = try await networkManager.generateEssay(
                    settings: settings,
                    userId: authManager.userId ?? ""
                )
                
                if let pdfData = Data(base64Encoded: response.pdfData) {
                    generatedPDF = pdfData
                    essayTitle = response.title
                }
                
                authManager.fetchUserData()
            } catch {
                print("Error generating essay: \(error)")
            }
            
            isGenerating = false
        }
    }
    
    private func sharePDF() {
        guard let pdfData = generatedPDF else { return }
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("essay.pdf")
        try? pdfData.write(to: tempURL)
        
        let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - Form Field

struct FormField<Content: View>: View {
    let title: String
    var placeholder: String = ""
    @ViewBuilder let content: Content
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(themeManager.font(size: 14, weight: .medium))
                .foregroundColor(themeManager.textColor)
            
            content
                .padding()
                .background(themeManager.backgroundColor)
                .cornerRadius(8)
        }
    }
}

// MARK: - PDF Viewer

struct PDFViewerView: View {
    let pdfData: Data
    let title: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            PDFKitView(data: pdfData)
                .navigationTitle(title)
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
}

struct PDFKitView: UIViewRepresentable {
    let data: Data
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = PDFDocument(data: data)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {}
}

#Preview {
    EssayWriterView()
        .environmentObject(AuthenticationManager.shared)
        .environmentObject(NetworkManager.shared)
        .environmentObject(ThemeManager.shared)
}

