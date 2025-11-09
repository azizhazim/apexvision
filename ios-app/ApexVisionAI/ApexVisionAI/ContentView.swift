//
//  ContentView.swift
//  ApexVisionAI
//
//  Main navigation and content view
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView(selectedTab: $selectedTab)
            } else {
                AuthenticationView()
            }
        }
        .onAppear {
            authManager.checkAuthenticationStatus()
        }
    }
}

struct MainTabView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Chat/AI Assistant Tab
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
                .tag(0)
            
            // Image Analysis Tab
            ImageAnalysisView()
                .tabItem {
                    Label("Scan", systemImage: "camera.fill")
                }
                .tag(1)
            
            // Exam Prediction Tab
            ExamPredictionView()
                .tabItem {
                    Label("Exam Prep", systemImage: "brain.head.profile")
                }
                .tag(2)
            
            // Essay Writer Tab
            EssayWriterView()
                .tabItem {
                    Label("Essay", systemImage: "doc.text.fill")
                }
                .tag(3)
            
            // More Features Tab
            MoreFeaturesView()
                .tabItem {
                    Label("More", systemImage: "ellipsis.circle.fill")
                }
                .tag(4)
        }
        .accentColor(themeManager.primaryBlue)
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationManager.shared)
        .environmentObject(ThemeManager.shared)
        .environmentObject(NetworkManager.shared)
}

