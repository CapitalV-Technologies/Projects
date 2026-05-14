//
//  AuthManager.swift
//  Taskly
//
//  Created by Nader Alfares on 3/16/26.
//

import Foundation
import SwiftUI

@Observable
class AuthManager {
    private(set) var accessToken: String?
    private(set) var isAuthenticated: Bool = false
        
    private let tokenKey = "accessToken"
    
    var errorMessage: String?
    
    init() {
        loadToken()
    }
    
    func setToken(_ token: String) {
        self.accessToken = token
        self.isAuthenticated = true
        self.saveToken(token)
    }
    
    func logout() {
        self.deleteToken()
        self.accessToken = nil
        self.isAuthenticated = false
    }
    
    private func loadToken() {
        if let token = UserDefaults.standard.string(forKey: tokenKey) {
            self.accessToken = token
            self.isAuthenticated = true
        }
    }
    
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    private func deleteToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
}
