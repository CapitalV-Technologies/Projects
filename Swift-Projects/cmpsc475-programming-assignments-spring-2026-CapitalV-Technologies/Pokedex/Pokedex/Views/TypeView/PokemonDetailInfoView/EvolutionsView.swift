//
//  EvolutionView.swift
//  Pokedex
//
//  Created by LiasPub on 4/2/26.
//

import SwiftUI

struct EvolutionsView: View {
    @Environment(AuthManager.self) var authManager: AuthManager
    @Environment(NetworkManager.self) var networkManager: NetworkManager
    var pokemon: Pokemon
    @State private var loadedPokemon: [Int: Pokemon] = [:]
    var width: CGFloat
    var body: some View {
        let height: CGFloat = 300
        let cornerRadius: CGFloat = 16
        let shadow: CGFloat = 5
        let padding: CGFloat = 10
        let imageWidth: CGFloat = 90
        let imageHeight: CGFloat = 90
        VStack (alignment: .leading, spacing: padding) {
            Text("Evolutions:")
                .bold()
                .font(.title2)
                .padding(.horizontal, padding)
            ScrollView (.horizontal) {
                HStack {
                    Text ("Prev:")
                        .font(.footnote)
                    if let prevs = pokemon.prev_evolution {
                        ForEach(prevs, id: \.self) { id in
                            if let pokemon = loadedPokemon[id] {
                                ImageView(pokemon: pokemon, imageWidth: imageWidth, imageHeight: imageHeight, width: width / 3, height: height / 1.5)
                            } else {
                                ProgressView()
                                    .task {
                                        await loadPokemon(id: id)
                                    }
                            }
                        }
                    }
                    Text ("Next:")
                        .font(.footnote)
                    if let next = pokemon.next_evolution {
                        ForEach(next, id: \.self) { id in
                            if let pokemon = loadedPokemon[id] {
                                ImageView(pokemon: pokemon, imageWidth: imageWidth, imageHeight: imageHeight, width: width / 3, height: height / 1.5)
                            } else {
                                ProgressView()
                                    .task {
                                        await loadPokemon(id: id)
                                    }
                            }
                        }
                    }
                }
            }
            
        }
        .padding(.horizontal, padding)
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: cornerRadius).fill(.white).shadow(radius: shadow))
        .padding(.horizontal, padding / 2)
    }
    
    private func loadPokemon(id: Int) async {
        Task {
            do {
                let pokemon = try await networkManager.getPokemon(id: id)
                loadedPokemon[id] = pokemon
            } catch {
                print("Error loading Pokemon")
            }
        }
    }
}






#Preview {
    EvolutionsView(pokemon: Pokemon.standard, width: 360)
        .environment(AuthManager())
        .environment(NetworkManager())
}
