//
//  SettingsView.swift
//  ApexVisionAI
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $themeManager.isDarkMode)
                    
                    Picker("Font Size", selection: $themeManager.fontSize) {
                        ForEach(ThemeManager.FontSize.allCases, id: \.self) { size in
                            Text(size.rawValue).tag(size)
                        }
                    }
                }
                
                Section("Account") {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(authManager.userEmail ?? "N/A")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Subscription")
                        Spacer()
                        Text(authManager.subscriptionLevel)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Requests Used")
                        Spacer()
                        Text("\(authManager.requestCount)")
                            .foregroundColor(.gray)
                    }
                }
                
                Section("About") {
                    Link("Visit Website", destination: URL(string: "https://apexvision.ai")!)
                    Link("YouTube", destination: URL(string: "https://youtube.com/@ApexVisionAI")!)
                    Link("Instagram", destination: URL(string: "https://instagram.com/apexvision.ai")!)
                    Link("TikTok", destination: URL(string: "https://tiktok.com/@apexvisionai")!)
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
                
                Section {
                    Button("Sign Out", role: .destructive) {
                        authManager.signOut()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Settings")
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

