//
//  ContentView.swift
//  Pokedex
//
//  Created by LiasPub on 3/21/26.
//

import SwiftUI

struct MainView: View {
    @Environment(AuthManager.self) var authManager: AuthManager
    @Environment(NetworkManager.self) var networkManager: NetworkManager
    
    @State private var allPokemon: [Pokemon] = []
    @State private var isLoading = false
    @State private var showError = false
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                TabView() {
                    ListView(items: $allPokemon)
                        .tabItem {
                            Label("Lists", systemImage: "list.bullet")
                        }
                    TypeView(allPokemon: $allPokemon)
                        .tabItem {
                            Label("Types", systemImage: "square.grid.2x2.fill")
                        }
                    AccountView()
                        .tabItem {
                            Label("Account", systemImage: "person.crop.circle")
                        }
                }
            }
        }
        .onAppear { loadTasks() }
        .refreshable { await loadTasksAsync() }
        .alert("Error", isPresented: $showError) {
                        Button("OK") { showError = false }
                    } message: {
                        Text(authManager.errorMessage ?? "An unknown error occurred")
                    }
    }
    
    private func loadTasks() {
            Task {
                await loadTasksAsync()
            }
        }
        
    private func loadTasksAsync() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            allPokemon = try await networkManager.getPokemonCollection()
        } catch {
            showError = true
        }
    }
}

#Preview {
    MainView()
        .environment(AuthManager())
        .environment(NetworkManager())
}
