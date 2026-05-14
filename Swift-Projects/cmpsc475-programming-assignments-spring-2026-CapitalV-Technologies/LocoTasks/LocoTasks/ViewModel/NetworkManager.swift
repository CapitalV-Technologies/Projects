//
//  NetworkManager.swift
//  Taskly
//
//  Created by Nader Alfares on 3/1/26.
//
import Foundation
import SwiftUI

@Observable
class NetworkManager {
    
    var ipAddress: String = "http://localhost:8000"
    private var authManager: AuthManager?
    
    // MARK: - Configuration
    func configure(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    // MARK: - Authentication Methods
    func signup(email: String, password: String) async throws -> TokenResponse {
        guard let url = URL(string: "\(ipAddress)/signup") else {
            throw NetworkError.invalidURL
        }
        
        let payload = SignupRequest(email: email, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 400 {
            throw NetworkError.emailAlreadyRegistered
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(TokenResponse.self, from: data)
    }
    
    func login(email: String, password: String) async throws -> TokenResponse {
        guard let url = URL(string: "\(ipAddress)/login") else {
            throw NetworkError.invalidURL
        }
        
        let payload = LoginRequest(email: email, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.invalidCredentials
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(TokenResponse.self, from: data)
    }
    
    func getJournalEntries() async throws -> [JournalEntry] {
        guard let url = URL(string: "\(ipAddress)/entries") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([JournalEntry].self, from: data)
    }
    
    // MARK: - Get Tasks
    func getTasks() async throws -> [TasklyItem] {
        guard let url = URL(string: "\(ipAddress)/tasks") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([TasklyItem].self, from: data)
    }
    
    func getTasksByEmail(email: String) async throws -> [TasklyItem] {
        guard let url = URL(string: "\(ipAddress)/tasks/email/\(email)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([TasklyItem].self, from: data)
    }
    
    func getGroups() async throws -> [GroupItem] {
        guard let url = URL(string: "\(ipAddress)/groups") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([GroupItem].self, from: data)
    }
    
    func createGroup(title: String) async throws -> GroupItem {
        guard let url = URL(string: "\(ipAddress)/groups") else {
            throw NetworkError.invalidURL
        }
        
        let groupData : [String: Any] = [
            "title": title
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: groupData, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        
        let decoder = JSONDecoder()
        let createdGroup = try decoder.decode(GroupItem.self, from: data)
        return createdGroup
    }
    // MARK: - Create Task
    
    func createTask(title: String, description: String, difficulty: Double, longitude: Double, latitude: Double) async throws -> TasklyItem {
        guard let url = URL(string: "\(ipAddress)/tasks") else {
            throw NetworkError.invalidURL
        }
        
        let taskData : [String: Any] = [
            "title": title,
            "description": description,
            "difficulty": difficulty,
            "longitude": longitude,
            "latitude": latitude
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: taskData, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        
        let decoder = JSONDecoder()
        let createdTask = try decoder.decode(TasklyItem.self, from: data)
        return createdTask
    }
    
    func createTaskForMember(title: String, description: String, difficulty: Double, longitude: Double, latitude: Double, email: String) async throws -> TasklyItem {
        guard let url = URL(string: "\(ipAddress)/tasks/\(email)") else {
            throw NetworkError.invalidURL
        }
        
        let taskData : [String: Any] = [
            "title": title,
            "description": description,
            "difficulty": difficulty,
            "longitude": longitude,
            "latitude": latitude
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: taskData, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        
        let decoder = JSONDecoder()
        let createdTask = try decoder.decode(TasklyItem.self, from: data)
        return createdTask
    }
    
    func createEntry(title: String, date: String, journalEntry: String, emotion: String, longitude: Double, latitude: Double) async throws -> JournalEntry {
        guard let url = URL(string: "\(ipAddress)/entries") else {
            throw NetworkError.invalidURL
        }
        
        let entryData : [String: Any] = [
            "title": title,
            "date": date,
            "journalEntry": journalEntry,
            "emotion": emotion,
            "longitude": longitude,
            "latitude": latitude
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: entryData, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        
        let decoder = JSONDecoder()
        let createdEntry = try decoder.decode(JournalEntry.self, from: data)
        return createdEntry
    }
    
    func deleteTask(taskId: String) async throws {
        guard let url = URL(string: "\(ipAddress)/tasks/\(taskId)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
    }
    
    func deleteGroup(groupTitle: String) async throws {
        guard let url = URL(string: "\(ipAddress)/groups/\(groupTitle)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
    }
    
    func deleteEntry(entryId: String) async throws {
        guard let url = URL(string: "\(ipAddress)/entries/\(entryId)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
    }
    
    // MARK: - Mark Task as Complete/Incomplete
    func markTaskAs(completed: Bool, taskId: String) async throws {
        // Determine the endpoint based on completed status
        let endpoint = completed ? "complete" : "incomplete"
        
        // Construct the URL
        guard let url = URL(string: "\(ipAddress)/tasks/\(taskId)/\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Perform the request
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Check the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
    }
    
    func updateTask(taskId: String, with updatedTask : TasklyItem) async throws {
        // Construct the URL
        guard let url = URL(string: "\(ipAddress)/tasks/\(taskId)") else {
            throw NetworkError.invalidURL
        }
        
        let taskData: [String: Any] = [
            "id": updatedTask.id,
            "title": updatedTask.title,
            "description": updatedTask.description,
            "difficulty": updatedTask.difficulty,
            "longitude": updatedTask.longitude,
            "latitude": updatedTask.latitude,
            "completed": updatedTask.completed
        ]
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Encode the body
        request.httpBody = try JSONSerialization.data(withJSONObject: taskData)
        
        // Perform the request
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Check the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
    }
    
    func addMember(email: String, with updatedGroup : GroupItem) async throws {
        // Construct the URL
        guard let url = URL(string: "\(ipAddress)/groups/\(email)") else {
            throw NetworkError.invalidURL
        }
        let updatedMembers = updatedGroup.members + [email]
        let groupData: [String: Any] = [
            "id": updatedGroup.id,
            "title": updatedGroup.title,
            "owner_id": updatedGroup.ownerId,
            "members": updatedMembers
        ]
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Encode the body
        request.httpBody = try JSONSerialization.data(withJSONObject: groupData)
        
        // Perform the request
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Check the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
    }
    
    
    // MARK: - Network Errors
    enum NetworkError: LocalizedError {
        case invalidURL
        case invalidResponse
        case httpError(statusCode: Int)
        case unauthorized
        case invalidCredentials
        case emailAlreadyRegistered
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The URL is invalid."
            case .invalidResponse:
                return "The server response was invalid."
            case .httpError(let statusCode):
                return "Request failed with status code: \(statusCode)"
            case .unauthorized:
                return "You need to log in to access this resource."
            case .invalidCredentials:
                return "Invalid email or password."
            case .emailAlreadyRegistered:
                return "This email is already registered."
            }
        }
    }
}
