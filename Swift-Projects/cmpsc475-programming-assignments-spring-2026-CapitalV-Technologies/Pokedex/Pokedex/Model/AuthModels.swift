//
//  AuthModels.swift
//  Pokedex
//
//  Created by LiasPub on 4/1/26.
//

import Foundation

//Stole from Taskly and changed if needed

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

struct User: Codable {
    let id: String
    let email: String
}
