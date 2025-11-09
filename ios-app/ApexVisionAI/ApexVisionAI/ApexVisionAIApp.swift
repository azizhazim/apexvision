//
//  ApexVisionAIApp.swift
//  ApexVisionAI
//
//  Created by ApexVision AI Team
//  Copyright © 2025 ApexVision AI. All rights reserved.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
struct ApexVisionAIApp: App {
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var networkManager = NetworkManager.shared
    
    init() {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Configure appearance
        setupAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(themeManager)
                .environmentObject(networkManager)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
    
    private func setupAppearance() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1.0) // #4A90E2
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

