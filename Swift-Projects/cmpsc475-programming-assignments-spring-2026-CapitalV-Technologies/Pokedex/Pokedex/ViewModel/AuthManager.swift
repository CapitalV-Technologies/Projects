//
//  AuthManager.swift
//  Pokedex
//
//  Created by Nader Alfares on 3/6/26.
//
import Foundation
import SwiftUI


@Observable
class AuthManager {
    //TODO: published properties for authenticated user
    // Private variable, but can be read from outside sources, but can only be written from inside AuthManager
    private(set) var isAuthenticated: Bool = false
    private(set) var accessToken: String?
    private(set) var userEmail: String?
    
    //(recommended) use in your views to show an alert for errors
    var errorMessage: String?
    
    //UserDefaults keys
    private let tokenKey = "pokedex_access_token"
    private let userEmailKey = "pokedex_user_email"
    
    init() {
        // immediate login for persisted user credentials
        loadAuthUser()
    }
    
    
    func setUser(email: String, _ token: String) {
        //TODO: set authenticated user's credentials (login)
        saveToken(token)
        saveUserEmail(email)
        self.userEmail = email
        self.accessToken = token
        self.isAuthenticated = true
    }
    
    func resetAuthState() {
        //TODO: reset propeties of AuthManager (logout)
        deleteToken()
        deleteUserEmail()
        self.isAuthenticated = false
        self.accessToken = nil
        self.userEmail = nil
    }
    
    // MARK: - Private Methods
    
    // These functions allow for persistence even when the app closes
    
    // Helper functions for UserDefaults
    private func loadAuthUser() {
        //TODO: load user credentials from UserDefaults
        if let token = UserDefaults.standard.string(forKey: tokenKey) {
            self.accessToken = token
            self.isAuthenticated = true
        }
        if let email = UserDefaults.standard.string(forKey: userEmailKey) {
            self.userEmail = email
        }
    }
    private func saveToken(_ token: String) {
        //TODO: save token in UserDefualts
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    private func deleteToken() {
        //TODO: save token in UserDefualts
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    private func saveUserEmail(_ email: String) {
        //TODO: save user email in UserDefualts
        UserDefaults.standard.set(email, forKey: userEmailKey)
    }
    private func deleteUserEmail() {
        //TODO: delete user email in UserDefualts
        UserDefaults.standard.removeObject(forKey: userEmailKey)
    }
    
}

