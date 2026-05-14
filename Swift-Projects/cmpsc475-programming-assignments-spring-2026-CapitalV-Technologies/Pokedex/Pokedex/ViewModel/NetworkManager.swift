//
//  NetworkManager.swift
//  Pokedex
//
//  Created by Nader Alfares on 3/6/26.
//
import Foundation
import SwiftUI


@Observable
class NetworkManager {
    
    //NOTE: Stole from Taskly and then changed to work from my code
    
    //IP address of our server running locally
    static let ipAddress : String = "http://localhost:8000"
    private var authManager: AuthManager?
    
    private var error: NetworkError = .invalidURL
    
    func configure(with authManager: AuthManager) {
        //provide access to authManager singlton (single source of truth)
        self.authManager = authManager
    }
    
    func signup(email: String, password: String) async throws -> TokenResponse {
        guard let url = URL(string: "\(NetworkManager.ipAddress)/auth/signup") else {
            error = .invalidURL
            authManager?.errorMessage = error.errorDescription
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
            error = .invalidResponse
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 400 {
            error = .emailAlreadyRegistered
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.emailAlreadyRegistered
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            error = .httpError(statusCode: httpResponse.statusCode)
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(TokenResponse.self, from: data)
    }
    
    
    
    func login(email: String, password: String) async throws -> TokenResponse {
        //TODO: Implement API request for user login
        
        guard let url = URL(string: "\(NetworkManager.ipAddress)/auth/login") else {
            error = .invalidURL
            authManager?.errorMessage = error.errorDescription
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
            error = .invalidResponse
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            error = .invalidCredentials
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.invalidCredentials
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            error = .httpError(statusCode: httpResponse.statusCode)
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(TokenResponse.self, from: data)
    }
    
    func getPokemonCollection() async throws -> [Pokemon] {
        //TODO: Implement API request to get Pokemon collection
        guard let url = URL(string: "\(NetworkManager.ipAddress)/pokemon") else {
            error = .invalidURL
            authManager?.errorMessage = error.errorDescription
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
            error = .invalidResponse
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.invalidResponse
        }
        
        // Authorization checking based on token implemented on the backend. Will give error if not authorized
        if httpResponse.statusCode == 401 {
            error = .unauthorized
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            error = .invalidResponse
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([Pokemon].self, from: data)
    }

    func getPokemon(id: Int) async throws -> Pokemon {
        //TODO: Implement API request to get a specific Pokemon by their id
        guard let url = URL(string: "\(NetworkManager.ipAddress)/pokemon/\(id)") else {
            error = .invalidURL
            authManager?.errorMessage = error.errorDescription
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
            error = .invalidResponse
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.invalidResponse
        }
        
        // Authorization checking based on token implemented on the backend. Will give error if not authorized
        if httpResponse.statusCode == 401 {
            error = .unauthorized
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            error = .invalidResponse
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(Pokemon.self, from: data)
        
    }
    
    static func getImageURL(for pokemonId: Int) -> URL? {
        // use this URL in AsyncImage
        return URL(string: "\(NetworkManager.ipAddress)/pokemon/\(pokemonId)/image")
    }
    
    func setCapture(for pokemonId: Int, isCaptured: Bool) async throws {
        //TODO: implement capture/release of Pokemon using API endpoints pokemon/{id}/capture and pokemon/{id}/release
        var endpoint = "capture"
        if !isCaptured {
            endpoint = "release"
        }
        
        guard let url = URL(string: "\(NetworkManager.ipAddress)/pokemon/\(String(pokemonId))/\(endpoint)") else {
            error = .invalidURL
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        if let token = authManager?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            error = .invalidResponse
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.invalidResponse
        }
        
        // Authorization checking based on token implemented on the backend. Will give error if not authorized
        if httpResponse.statusCode == 401 {
            error = .unauthorized
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            error = .invalidResponse
            authManager?.errorMessage = error.errorDescription
            throw NetworkError.invalidResponse
        }
    }
    
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



