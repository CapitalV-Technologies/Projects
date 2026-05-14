//
//  AuthContainerView.swift
//  Pokedex
//
//  Created by LiasPub on 4/1/26.
//

import SwiftUI

struct AuthContainerView: View {
    @Environment(AuthManager.self) var authManager: AuthManager
    @Environment(NetworkManager.self) var networkManager: NetworkManager
    var body: some View {
            Group {
                if authManager.isAuthenticated {
                    MainView()
                } else {
                    LoginView()
                }
            }
        }
}

#Preview {
    AuthContainerView()
        .environment(AuthManager())
        .environment(NetworkManager())
}
