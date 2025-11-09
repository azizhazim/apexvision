//
//  HistoryView.swift
//  ApexVisionAI
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: ChatViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.sessions) { session in
                    Button(action: {
                        viewModel.loadSession(session)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.messages.first?.text.prefix(50) ?? "Empty session")
                                .font(themeManager.font(size: 16))
                                .foregroundColor(themeManager.textColor)
                            
                            Text(session.updatedAt, style: .relative)
                                .font(themeManager.font(size: 12))
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        viewModel.deleteSession(viewModel.sessions[index])
                    }
                }
            }
            .navigationTitle("Chat History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear All") {
                        viewModel.clearAllSessions()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

