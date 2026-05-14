//
//  PokemonCardView.swift
//  Pokedex
//
//  Created by LiasPub on 3/22/26.
//

import SwiftUI

struct PokemonCardView: View {
    var pokemon: Pokemon
    @Binding var allPokemon: [Pokemon]
    var body: some View {
        let width: CGFloat = 120
        let height: CGFloat = 200
        let imageWidth: CGFloat = 60
        let imageHeight: CGFloat = 60
        let offsetX: CGFloat = 40
        let offsetY: CGFloat = -80
        // Won't work in this preview, but will work in Type View with added Navigation Stack
        NavigationLink {
            PokemonDetailInfoView(allPokemon: $allPokemon, pokemon: pokemon)
        } label: {
            VStack {
                ZStack {
                    
                    ImageView(pokemon: pokemon, imageWidth: imageWidth, imageHeight: imageHeight, width: width, height: height)
                    if pokemon.captured {
                        Image("PokemonBall")
                            .resizable()
                            .frame(width: imageWidth / 2, height: imageHeight / 2)
                            .offset(x: offsetX, y: offsetY)
                    }
                }
            }
        }
    }
    
}
