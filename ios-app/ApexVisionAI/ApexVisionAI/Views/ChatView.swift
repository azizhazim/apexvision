//
//  ChatView.swift
//  ApexVisionAI
//
//  Main chat interface for AI assistance
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @StateObject private var viewModel = ChatViewModel()
    @State private var messageText = ""
    @State private var showingHistory = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with stats
                headerView
                
                // Messages list
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.currentSession.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.currentSession.messages.count) { _ in
                        if let lastMessage = viewModel.currentSession.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Quick actions
                if viewModel.currentSession.messages.isEmpty {
                    quickActionsView
                }
                
                // Input area
                inputView
            }
            .background(themeManager.backgroundColor)
            .navigationTitle("AI Assistant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingHistory = true }) {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .sheet(isPresented: $showingHistory) {
                HistoryView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Requests: \(authManager.requestCount)")
                        .font(themeManager.font(size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    Text(authManager.subscriptionLevel)
                        .font(themeManager.font(size: 10, weight: .medium))
                        .foregroundColor(themeManager.primaryColor)
                }
                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            Divider()
        }
        .background(themeManager.cardBackgroundColor)
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(themeManager.font(size: 16, weight: .semibold))
                .foregroundColor(themeManager.textColor)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(QuickAction.allCases, id: \.self) { action in
                        QuickActionButton(action: action) {
                            messageText = action.prompt
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
    
    // MARK: - Input View
    
    private var inputView: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                TextField("Ask me anything...", text: $messageText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(20)
                    .lineLimit(1...5)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(messageText.isEmpty ? .gray : themeManager.primaryColor)
                }
                .disabled(messageText.isEmpty || viewModel.isLoading)
            }
            .padding()
            .background(themeManager.backgroundColor)
        }
    }
    
    // MARK: - Actions
    
    private func sendMessage() {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        messageText = ""
        
        Task {
            await viewModel.sendMessage(text, userId: authManager.userId ?? "")
        }
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: ChatMessage
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(themeManager.font(size: 15))
                    .foregroundColor(message.isUser ? .white : themeManager.textColor)
                    .padding(12)
                    .background(message.isUser ? themeManager.primaryColor : themeManager.cardBackgroundColor)
                    .cornerRadius(16)
                
                Text(message.timestamp, style: .time)
                    .font(themeManager.font(size: 10))
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            .contextMenu {
                Button(action: {
                    UIPasteboard.general.string = message.text
                }) {
                    Label("Copy", systemImage: "doc.on.doc")
                }
            }
            
            if !message.isUser { Spacer() }
        }
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let action: QuickAction
    let onTap: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(action.emoji)
                    .font(.system(size: 32))
                
                Text(action.title)
                    .font(themeManager.font(size: 12, weight: .medium))
                    .foregroundColor(themeManager.textColor)
            }
            .frame(width: 100, height: 100)
            .background(themeManager.cardBackgroundColor)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Quick Action Enum

enum QuickAction: CaseIterable {
    case explain, solveMath, summarize, proofread, research, checkWork
    
    var emoji: String {
        switch self {
        case .explain: return "📝"
        case .solveMath: return "🧮"
        case .summarize: return "📚"
        case .proofread: return "✍️"
        case .research: return "🔍"
        case .checkWork: return "✅"
        }
    }
    
    var title: String {
        switch self {
        case .explain: return "Explain This"
        case .solveMath: return "Solve Math"
        case .summarize: return "Summarize"
        case .proofread: return "Proofread"
        case .research: return "Research"
        case .checkWork: return "Check Work"
        }
    }
    
    var prompt: String {
        switch self {
        case .explain: return "Can you explain this concept to me?"
        case .solveMath: return "Help me solve this math problem: "
        case .summarize: return "Can you summarize this for me?"
        case .proofread: return "Please proofread and improve this text: "
        case .research: return "Help me research information about: "
        case .checkWork: return "Can you check if this is correct?"
        }
    }
}

#Preview {
    ChatView()
        .environmentObject(AuthenticationManager.shared)
        .environmentObject(NetworkManager.shared)
        .environmentObject(ThemeManager.shared)
}

