//
//  ImageAnalysisView.swift
//  ApexVisionAI
//
//  Image analysis and OCR functionality
//

import SwiftUI
import PhotosUI

struct ImageAnalysisView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var analysisResult: String?
    @State private var isAnalyzing = false
    @State private var useMathpix = false
    @State private var showingResult = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView
                    
                    // Image preview
                    if let image = selectedImage {
                        imagePreviewView(image: image)
                    } else {
                        placeholderView
                    }
                    
                    // Mathpix toggle (for Mastermind subscribers)
                    if authManager.isMastermindSubscriber() {
                        mathpixToggle
                    }
                    
                    // Action buttons
                    actionButtons
                    
                    // Result
                    if let result = analysisResult {
                        resultView(result: result)
                    }
                    
                    // Instructions
                    instructionsView
                }
                .padding()
            }
            .background(themeManager.backgroundColor)
            .navigationTitle("Image Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(image: $selectedImage, sourceType: .camera)
            }
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 60))
                .foregroundColor(themeManager.primaryColor)
            
            Text("Scan & Solve")
                .font(themeManager.font(size: 24, weight: .bold))
                .foregroundColor(themeManager.textColor)
            
            Text("Take a photo or upload an image to get instant answers")
                .font(themeManager.font(size: 14))
                .foregroundColor(themeManager.secondaryTextColor)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    // MARK: - Image Preview
    
    private func imagePreviewView(image: UIImage) -> some View {
        VStack(spacing: 12) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            
            Button(action: { selectedImage = nil; analysisResult = nil }) {
                Label("Remove Image", systemImage: "trash")
                    .font(themeManager.font(size: 14))
                    .foregroundColor(.red)
            }
        }
    }
    
    // MARK: - Placeholder
    
    private var placeholderView: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 80))
                .foregroundColor(themeManager.secondaryTextColor.opacity(0.5))
            
            Text("No image selected")
                .font(themeManager.font(size: 16))
                .foregroundColor(themeManager.secondaryTextColor)
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
    }
    
    // MARK: - Mathpix Toggle
    
    private var mathpixToggle: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(isOn: $useMathpix) {
                HStack {
                    Image(systemName: "function")
                        .foregroundColor(themeManager.primaryColor)
                    Text("Advanced Math Processing")
                        .font(themeManager.font(size: 14, weight: .medium))
                }
            }
            .tint(themeManager.primaryColor)
            
            Text("Use Mathpix for complex equations and graphs (Mastermind only)")
                .font(themeManager.font(size: 12))
                .foregroundColor(themeManager.secondaryTextColor)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button(action: { showingCamera = true }) {
                    Label("Take Photo", systemImage: "camera.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(themeManager.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Button(action: { showingImagePicker = true }) {
                    Label("Choose Photo", systemImage: "photo.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(themeManager.secondaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            
            if selectedImage != nil {
                Button(action: analyzeImage) {
                    HStack {
                        if isAnalyzing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Analyzing...")
                        } else {
                            Image(systemName: "sparkles")
                            Text("Analyze Image")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(isAnalyzing)
            }
        }
    }
    
    // MARK: - Result View
    
    private func resultView(result: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Analysis Result")
                    .font(themeManager.font(size: 18, weight: .semibold))
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                Button(action: {
                    UIPasteboard.general.string = result
                }) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(themeManager.primaryColor)
                }
            }
            
            Text(result)
                .font(themeManager.font(size: 15))
                .foregroundColor(themeManager.textColor)
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(12)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Instructions
    
    private var instructionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How it works:")
                .font(themeManager.font(size: 16, weight: .semibold))
                .foregroundColor(themeManager.textColor)
            
            InstructionRow(icon: "1.circle.fill", text: "Take a photo or select from library")
            InstructionRow(icon: "2.circle.fill", text: "Tap 'Analyze Image' to process")
            InstructionRow(icon: "3.circle.fill", text: "Get instant answers and explanations")
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
    }
    
    // MARK: - Analyze Image
    
    private func analyzeImage() {
        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let base64String = "data:image/jpeg;base64," + imageData.base64EncodedString()
        
        isAnalyzing = true
        analysisResult = nil
        
        Task {
            do {
                let response = try await networkManager.analyzeImage(
                    imageData: base64String,
                    userId: authManager.userId ?? "",
                    useMathpix: useMathpix
                )
                
                analysisResult = response.answer
                authManager.fetchUserData() // Update request count
            } catch {
                analysisResult = "Error: \(error.localizedDescription)"
            }
            
            isAnalyzing = false
        }
    }
}

// MARK: - Instruction Row

struct InstructionRow: View {
    let icon: String
    let text: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(themeManager.primaryColor)
                .font(.system(size: 20))
            
            Text(text)
                .font(themeManager.font(size: 14))
                .foregroundColor(themeManager.textColor)
        }
    }
}

#Preview {
    ImageAnalysisView()
        .environmentObject(AuthenticationManager.shared)
        .environmentObject(NetworkManager.shared)
        .environmentObject(ThemeManager.shared)
}

