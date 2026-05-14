//
//  AuthModels.swift
//  Taskly
//
//  Created by Nader Alfares on 3/16/26.
//

import Foundation

// MARK: - Request Models
struct SignupRequest: Codable {
    let email: String
    let password: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

// MARK: - Response Models

struct TokenResponse: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

struct User: Codable, Identifiable {
    let id: String
    let email: String
}
