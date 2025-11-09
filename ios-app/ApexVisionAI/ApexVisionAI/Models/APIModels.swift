//
//  APIModels.swift
//  ApexVisionAI
//
//  Data models for API responses
//

import Foundation

// MARK: - AI Response

struct AIResponse: Codable {
    let status: String
    let response: String?
    let error: String?
}

// MARK: - Image Analysis

struct ImageAnalysisResponse: Codable {
    let answer: String
    let error: String?
}

// MARK: - Exam Prediction

struct ExamPredictionResponse: Codable {
    let predictions: [ExamPrediction]
    let courseName: String
    let professorName: String
    let generatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case predictions
        case courseName = "course_name"
        case professorName = "professor_name"
        case generatedAt = "generated_at"
    }
}

struct ExamPrediction: Codable, Identifiable {
    let id = UUID()
    let question: String
    let topic: String
    let difficulty: String
    let reasoning: String
    let studyTips: String
    
    enum CodingKeys: String, CodingKey {
        case question, topic, difficulty, reasoning
        case studyTips = "study_tips"
    }
}

struct ExamAnswerResponse: Codable {
    let answer: String
    let question: String
    let topic: String
}

struct ExamLimitResponse: Codable {
    let used: Int
    let limit: Int
    let remaining: Int
}

// MARK: - Essay Writer

struct EssaySettings {
    var topic: String = ""
    var wordCount: Int = 500
    var essayType: String = "Argumentative"
    var academicLevel: String = "High School"
    var citationStyle: String = "MLA"
    var tone: String = "Formal"
    var includeCitations: Bool = true
    var includeOutline: Bool = true
}

struct EssayResponse: Codable {
    let pdfData: String
    let title: String
}

// MARK: - Study Guide

struct StudyGuideResponse: Codable {
    let studyGuide: String
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case studyGuide = "study_guide"
        case error
    }
}

// MARK: - Flashcards

struct FlashcardsResponse: Codable {
    let flashcards: String
    let error: String?
}

struct Flashcard: Codable, Identifiable {
    let id = UUID()
    let front: String
    let back: String
}

// MARK: - Math Solver

struct MathResponse: Codable {
    let solution: String
    let error: String?
}

// MARK: - Code Helper

struct CodeResponse: Codable {
    let solution: String
    let error: String?
}

// MARK: - Leaderboard

struct LeaderboardResponse: Codable {
    let rank: Int
    let totalUsers: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case rank
        case totalUsers = "total_users"
        case message
    }
}

struct LeaderboardDataResponse: Codable {
    let leaderboard: [LeaderboardEntry]
    let userRank: Int?
    
    enum CodingKeys: String, CodingKey {
        case leaderboard
        case userRank = "user_rank"
    }
}

struct LeaderboardEntry: Codable, Identifiable {
    let id = UUID()
    let userId: String
    let userName: String?
    let streak: Int
    let dailyQuestions: Int
    let totalDays: Int
    let score: Int
    let rank: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case streak
        case dailyQuestions = "daily_questions"
        case totalDays = "total_days"
        case score
        case rank
    }
}

// MARK: - Chat Message

struct ChatMessage: Identifiable, Codable {
    let id: String
    let text: String
    let isUser: Bool
    let timestamp: Date
    
    init(id: String = UUID().uuidString, text: String, isUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.isUser = isUser
        self.timestamp = timestamp
    }
}

// MARK: - Session

struct ChatSession: Identifiable, Codable {
    let id: String
    var messages: [ChatMessage]
    let createdAt: Date
    var updatedAt: Date
    
    init(id: String = UUID().uuidString, messages: [ChatMessage] = [], createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.messages = messages
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - User Stats

struct UserStats: Codable {
    var streak: Int = 0
    var dailyQuestions: Int = 0
    var totalDays: Int = 0
    var lastActiveDate: Date?

    mutating func incrementQuestion() {
        dailyQuestions += 1

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDate = lastActiveDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            let daysDifference = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0

            if daysDifference == 0 {
                // Same day, just increment
            } else if daysDifference == 1 {
                // Consecutive day, increment streak
                streak += 1
                totalDays += 1
                dailyQuestions = 1
            } else {
                // Streak broken
                streak = 1
                totalDays += 1
                dailyQuestions = 1
            }
        } else {
            // First time
            streak = 1
            totalDays = 1
            dailyQuestions = 1
        }

        lastActiveDate = Date()
    }
}

// MARK: - Uploaded File

struct UploadedFile: Identifiable {
    let id = UUID()
    let name: String
    let content: String
}

