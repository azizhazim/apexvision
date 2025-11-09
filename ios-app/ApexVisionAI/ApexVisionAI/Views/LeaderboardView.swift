//
//  LeaderboardView.swift
//  ApexVisionAI
//

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var leaderboard: [LeaderboardEntry] = []
    @State private var userRank: Int?
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    if let rank = userRank {
                        userRankCard(rank: rank)
                    }
                    
                    if isLoading {
                        ProgressView()
                    } else {
                        leaderboardList
                    }
                }
                .padding()
            }
            .background(themeManager.backgroundColor)
            .navigationTitle("Leaderboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                }
            }
            .onAppear(perform: loadLeaderboard)
        }
    }
    
    private func userRankCard(rank: Int) -> some View {
        VStack(spacing: 12) {
            Text("Your Rank")
                .font(themeManager.font(size: 16, weight: .semibold))
            
            Text("#\(rank)")
                .font(themeManager.font(size: 48, weight: .bold))
                .foregroundColor(themeManager.primaryColor)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(16)
    }
    
    private var leaderboardList: some View {
        VStack(spacing: 12) {
            ForEach(leaderboard) { entry in
                LeaderboardRow(entry: entry)
            }
        }
    }
    
    private func loadLeaderboard() {
        isLoading = true
        Task {
            do {
                let response = try await networkManager.getLeaderboard(userId: authManager.userId ?? "")
                leaderboard = response.leaderboard
                userRank = response.userRank
            } catch {
                print("Error: \(error)")
            }
            isLoading = false
        }
    }
}

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 16) {
            Text("#\(entry.rank)")
                .font(themeManager.font(size: 18, weight: .bold))
                .foregroundColor(rankColor)
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.userName ?? "User")
                    .font(themeManager.font(size: 16, weight: .medium))
                
                HStack(spacing: 12) {
                    Label("\(entry.streak)", systemImage: "flame.fill")
                    Label("\(entry.dailyQuestions)", systemImage: "questionmark.circle.fill")
                }
                .font(themeManager.font(size: 12))
                .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Spacer()
            
            Text("\(entry.score)")
                .font(themeManager.font(size: 20, weight: .bold))
                .foregroundColor(themeManager.primaryColor)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
    }
    
    private var rankColor: Color {
        switch entry.rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2)
        default: return themeManager.textColor
        }
    }
}

