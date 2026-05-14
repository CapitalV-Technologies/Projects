//
//  AccountView.swift
//  Pokedex
//
//  Created by LiasPub on 3/22/26.
//

import SwiftUI

struct AccountView: View {
    @Environment(AuthManager.self) var authManager: AuthManager
    @Environment(NetworkManager.self) var networkManager: NetworkManager
    var body: some View {
        let padding: CGFloat = 40
        ZStack {
            backgroundColor.ignoresSafeArea()
            ScrollView(.vertical) {
                VStack (alignment: .leading) {
                    Text("Account")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    AccountInfoView(color: .black, label: "Email", information: authManager.userEmail ?? "ERROR")
                        .frame(maxWidth: .infinity)
                    
                    // Logout Button
                    Button {
                        authManager.resetAuthState()
                    } label: {
                        AccountInfoView(color: .red, label: "Log Out")
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, padding)
                }
            }
        }
    }
    
    // Create an off white background Color
        let backgroundColor: LinearGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color.white,
                Color(red: 0.95, green: 0.94, blue: 0.88)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
}

#Preview {
    AccountView()
        .environment(AuthManager())
        .environment(NetworkManager())
}
