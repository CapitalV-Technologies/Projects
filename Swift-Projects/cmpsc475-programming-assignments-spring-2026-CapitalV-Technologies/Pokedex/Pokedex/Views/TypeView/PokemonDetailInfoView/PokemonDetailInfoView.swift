//
//  PokemonDetailInfoView.swift
//  Pokedex
//
//  Created by LiasPub on 3/31/26.
//

import SwiftUI

struct PokemonDetailInfoView: View {
    @Environment(AuthManager.self) var authManager: AuthManager
    @Environment(NetworkManager.self) var networkManager: NetworkManager
    @Binding var allPokemon: [Pokemon]
    var pokemon: Pokemon
    var body: some View {
        let width: CGFloat = 360
        let height: CGFloat = 200
        let padding: CGFloat = 20
        let imageWidth: CGFloat = 130
        let imageHeight: CGFloat = 130
        ScrollView (.vertical) {
            VStack (alignment: .leading, spacing: padding) {
                Text(pokemon.name)
                    .font(.largeTitle)
                    .bold()
                ImageView(pokemon: pokemon, imageWidth: imageWidth, imageHeight: imageHeight, width: width, height: height)
                    .frame(width: width, height: height)
                CaptureButtonView(allPokemon: $allPokemon, pokemon: pokemon, width: width)
                    
                HStack {
                    ForEach(pokemon.types) { type in
                        SmallTypeView(type: type)
                    }
                }
                
                StatsView(pokemon: pokemon, width: width)
                WeaknessesView(pokemon: pokemon, width: width)
                EvolutionsView(pokemon: pokemon, width: width)
                
            }
        }
    }
}
