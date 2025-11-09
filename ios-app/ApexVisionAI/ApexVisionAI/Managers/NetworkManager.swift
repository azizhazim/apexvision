//
//  NetworkManager.swift
//  ApexVisionAI
//
//  Handles all API communication with the backend
//

import Foundation
import Combine

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.apexvision.ai"
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {}
    
    // MARK: - Generic Request Method
    
    private func makeRequest<T: Decodable>(
        endpoint: String,
        method: String = "POST",
        body: [String: Any]? = nil,
        userId: String? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let userId = userId {
            request.setValue(userId, forHTTPHeaderField: "UserId")
        }
        
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
    
    // MARK: - Chat/AI Response

    func getAIResponse(userInput: String, userId: String) async throws -> AIResponse {
        let body: [String: Any] = ["userInput": userInput]
        return try await makeRequest(
            endpoint: "/get_gpt_response",
            body: body,
            userId: userId,
            responseType: AIResponse.self
        )
    }
    
    // MARK: - Image Analysis
    
    func analyzeImage(imageData: String, userId: String, useMathpix: Bool = false) async throws -> ImageAnalysisResponse {
        let body: [String: Any] = [
            "image": imageData,
            "useMathpix": useMathpix
        ]
        return try await makeRequest(
            endpoint: "/analyze_image",
            body: body,
            userId: userId,
            responseType: ImageAnalysisResponse.self
        )
    }
    
    // MARK: - Exam Prediction

    func predictExamQuestions(
        courseName: String,
        professorName: String,
        materials: [[String: String]],
        userId: String
    ) async throws -> ExamPredictionResponse {
        let body: [String: Any] = [
            "courseName": courseName,
            "professorName": professorName,
            "materials": materials
        ]
        return try await makeRequest(
            endpoint: "/exam_prediction",
            body: body,
            userId: userId,
            responseType: ExamPredictionResponse.self
        )
    }

    func generateExamAnswer(question: String, topic: String, userId: String) async throws -> ExamAnswerResponse {
        let body: [String: Any] = [
            "question": question,
            "topic": topic
        ]
        return try await makeRequest(
            endpoint: "/generate_answer",
            body: body,
            userId: userId,
            responseType: ExamAnswerResponse.self
        )
    }
    
    func checkExamLimit(userId: String) async throws -> ExamLimitResponse {
        return try await makeRequest(
            endpoint: "/exam_prediction/check_limit",
            method: "GET",
            userId: userId,
            responseType: ExamLimitResponse.self
        )
    }
    
    // MARK: - Essay Writer
    
    func generateEssay(settings: EssaySettings, userId: String) async throws -> EssayResponse {
        let body: [String: Any] = [
            "topic": settings.topic,
            "wordCount": settings.wordCount,
            "essayType": settings.essayType,
            "academicLevel": settings.academicLevel,
            "citationStyle": settings.citationStyle,
            "tone": settings.tone,
            "includeCitations": settings.includeCitations,
            "includeOutline": settings.includeOutline
        ]
        return try await makeRequest(
            endpoint: "/generate_essay",
            body: body,
            userId: userId,
            responseType: EssayResponse.self
        )
    }
    
    // MARK: - Study Guide
    
    func generateStudyGuide(conversation: String, userId: String) async throws -> StudyGuideResponse {
        let body: [String: Any] = ["userInput": conversation]
        return try await makeRequest(
            endpoint: "/study_guide_module",
            body: body,
            userId: userId,
            responseType: StudyGuideResponse.self
        )
    }
    
    // MARK: - Flashcards
    
    func generateFlashcards(topic: String, userId: String) async throws -> FlashcardsResponse {
        let body: [String: Any] = ["message": topic]
        return try await makeRequest(
            endpoint: "/flashcards",
            body: body,
            userId: userId,
            responseType: FlashcardsResponse.self
        )
    }
    
    // MARK: - Math Solver
    
    func solveMath(question: String, userId: String) async throws -> MathResponse {
        let body: [String: Any] = ["message": question]
        return try await makeRequest(
            endpoint: "/math",
            body: body,
            userId: userId,
            responseType: MathResponse.self
        )
    }
    
    // MARK: - Code Helper
    
    func getCodeHelp(prompt: String, userId: String) async throws -> CodeResponse {
        let body: [String: Any] = ["message": prompt]
        return try await makeRequest(
            endpoint: "/code",
            body: body,
            userId: userId,
            responseType: CodeResponse.self
        )
    }
    
    // MARK: - Leaderboard
    
    func submitLeaderboardStats(streak: Int, dailyQuestions: Int, totalDays: Int, userId: String) async throws -> LeaderboardResponse {
        let body: [String: Any] = [
            "streak": streak,
            "dailyQuestions": dailyQuestions,
            "totalDays": totalDays
        ]
        return try await makeRequest(
            endpoint: "/leaderboard/submit",
            body: body,
            userId: userId,
            responseType: LeaderboardResponse.self
        )
    }
    
    func getLeaderboard(userId: String) async throws -> LeaderboardDataResponse {
        return try await makeRequest(
            endpoint: "/leaderboard/global",
            method: "GET",
            userId: userId,
            responseType: LeaderboardDataResponse.self
        )
    }
}

// MARK: - Network Error

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let code):
            return "Server error: \(code)"
        case .decodingError:
            return "Failed to decode response"
        }
    }
}

