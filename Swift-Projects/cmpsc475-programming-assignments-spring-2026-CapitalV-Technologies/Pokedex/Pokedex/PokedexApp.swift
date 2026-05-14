//
//  PokedexApp.swift
//  Pokedex
//
//  Created by LiasPub on 3/21/26.
//

import SwiftUI

@main
struct PokedexApp: App {
    @State var authManager: AuthManager = AuthManager()
    @State var networkManager: NetworkManager = NetworkManager()
    var body: some Scene {
        WindowGroup {
            AuthContainerView()
                .environment(authManager.self)
                .environment(networkManager.self)
                .onAppear {
                    networkManager.configure(with: authManager)
                }
        }
    }
}
