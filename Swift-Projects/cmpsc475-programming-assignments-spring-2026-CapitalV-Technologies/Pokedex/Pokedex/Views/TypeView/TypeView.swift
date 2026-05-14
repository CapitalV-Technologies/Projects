//
//  TypeView.swift
//  Pokedex
//
//  Created by LiasPub on 3/22/26.
//

import SwiftUI

struct TypeView: View {
    @Binding var allPokemon: [Pokemon]
    var body: some View {
        let capturedCount = allPokemon.filter {$0.captured}.count
        var capturedPokemon: [Pokemon] {
            allPokemon.filter {$0.captured}
        }
        let padding: CGFloat = 10
        // Navigation Stack Must always be at the top!
        NavigationStack {
            ScrollView (.vertical) {
                VStack (alignment: .leading) {
                    Text("Types")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    if capturedCount != 0 {
                        HStack {
                            Text("Captured")
                                .bold()
                                .font(.title2)
                            Text("(\(capturedCount))")
                                .font(.subheadline)
                        }
                        .padding(.horizontal, padding)
                        ScrollView (.horizontal) {
                            HStack (spacing: padding) {
                                Spacer()
                                ForEach(capturedPokemon) { pokemon in
                                    PokemonCardView(pokemon: pokemon, allPokemon: $allPokemon)
                                }
                            }
                        }
                    }
                    ForEach(PokemonType.allCases) {type in
                        let (thisType, total) = findTypes(type: type)
                        HStack {
                            Text(type.id)
                                .bold()
                                .font(.title2)
                            Text("(\(total))")
                                .font(.subheadline)
                        }
                        .padding(.horizontal, padding)
                        ScrollView(.horizontal) {
                            HStack (spacing: padding){
                                Spacer()
                                ForEach(thisType) { pokemon in
                                    PokemonCardView(pokemon: pokemon, allPokemon: $allPokemon)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
     //Create a function that loops through our allPokemon list and returns a new list (and total) based on the type
    private func findTypes(type: PokemonType) -> ([Pokemon], Int) {
        var thisType: [Pokemon] = []
        var total = 0
        for pokemon in allPokemon {
            for oneType in pokemon.types {
                if oneType == type {
                    thisType.append(pokemon)
                    total += 1
                }
            }
        }
        return (thisType, total)
    }
}
