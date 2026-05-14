//
//  AuthContainerView.swift
//  LocoTasks
//
//
//

import SwiftUI

struct AuthContainerView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
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
        .environment(LocoTasksViewModel())
}
