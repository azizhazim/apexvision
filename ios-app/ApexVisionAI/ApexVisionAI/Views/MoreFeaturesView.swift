//
//  MoreFeaturesView.swift
//  ApexVisionAI
//
//  Additional features and tools
//

import SwiftUI

struct MoreFeaturesView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var showingFlashcards = false
    @State private var showingMathSolver = false
    @State private var showingCodeHelper = false
    @State private var showingStudyGuide = false
    @State private var showingLeaderboard = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // User profile section
                    profileSection
                    
                    // Features grid
                    featuresGrid
                    
                    // Account section
                    accountSection
                }
                .padding()
            }
            .background(themeManager.backgroundColor)
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingFlashcards) {
                FlashcardsView()
            }
            .sheet(isPresented: $showingMathSolver) {
                MathSolverView()
            }
            .sheet(isPresented: $showingCodeHelper) {
                CodeHelperView()
            }
            .sheet(isPresented: $showingStudyGuide) {
                StudyGuideView()
            }
            .sheet(isPresented: $showingLeaderboard) {
                LeaderboardView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
    
    // MARK: - Profile Section
    
    private var profileSection: some View {
        VStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(themeManager.primaryColor.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(
                    Text(authManager.userName?.prefix(1).uppercased() ?? "U")
                        .font(themeManager.font(size: 32, weight: .bold))
                        .foregroundColor(themeManager.primaryColor)
                )
            
            // User info
            VStack(spacing: 4) {
                Text(authManager.userName ?? "User")
                    .font(themeManager.font(size: 20, weight: .bold))
                    .foregroundColor(themeManager.textColor)
                
                Text(authManager.userEmail ?? "")
                    .font(themeManager.font(size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            // Subscription badge
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(authManager.subscriptionLevel)
                    .font(themeManager.font(size: 14, weight: .semibold))
                    .foregroundColor(themeManager.textColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(themeManager.cardBackgroundColor)
            .cornerRadius(20)
            
            // Stats
            HStack(spacing: 32) {
                StatItem(title: "Requests", value: "\(authManager.requestCount)")
                StatItem(title: "Free Left", value: "\(authManager.freeRequestsRemaining)")
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(16)
    }
    
    // MARK: - Features Grid
    
    private var featuresGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tools & Features")
                .font(themeManager.font(size: 20, weight: .bold))
                .foregroundColor(themeManager.textColor)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                FeatureCard(
                    icon: "rectangle.stack.fill",
                    title: "Flashcards",
                    color: .purple
                ) {
                    showingFlashcards = true
                }
                
                FeatureCard(
                    icon: "function",
                    title: "Math Solver",
                    color: .blue
                ) {
                    showingMathSolver = true
                }
                
                FeatureCard(
                    icon: "chevron.left.forwardslash.chevron.right",
                    title: "Code Helper",
                    color: .green
                ) {
                    showingCodeHelper = true
                }
                
                FeatureCard(
                    icon: "book.fill",
                    title: "Study Guide",
                    color: .orange
                ) {
                    showingStudyGuide = true
                }
                
                FeatureCard(
                    icon: "chart.bar.fill",
                    title: "Leaderboard",
                    color: .red
                ) {
                    showingLeaderboard = true
                }
                
                FeatureCard(
                    icon: "gearshape.fill",
                    title: "Settings",
                    color: .gray
                ) {
                    showingSettings = true
                }
            }
        }
    }
    
    // MARK: - Account Section
    
    private var accountSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                if let url = URL(string: "https://apexvision.ai") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "crown.fill")
                    Text("Upgrade Subscription")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                .background(themeManager.primaryColor)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            Button(action: {
                authManager.signOut()
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Sign Out")
                    Spacer()
                }
                .padding()
                .background(themeManager.cardBackgroundColor)
                .foregroundColor(.red)
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - Stat Item

struct StatItem: View {
    let title: String
    let value: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(themeManager.font(size: 24, weight: .bold))
                .foregroundColor(themeManager.primaryColor)
            
            Text(title)
                .font(themeManager.font(size: 12))
                .foregroundColor(themeManager.secondaryTextColor)
        }
    }
}

// MARK: - Feature Card

struct FeatureCard: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                
                Text(title)
                    .font(themeManager.font(size: 14, weight: .medium))
                    .foregroundColor(themeManager.textColor)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(themeManager.cardBackgroundColor)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    MoreFeaturesView()
        .environmentObject(AuthenticationManager.shared)
        .environmentObject(ThemeManager.shared)
}

