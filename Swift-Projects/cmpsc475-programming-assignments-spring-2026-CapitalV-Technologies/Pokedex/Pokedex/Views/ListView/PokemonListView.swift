//
//  PokemonListView.swift
//  Pokedex
//
//  Created by LiasPub on 3/22/26.
//

import SwiftUI

struct PokemonListView: View {
    var pokemon: Pokemon
    var body: some View {
        let shadowRadius: CGFloat = 4
        let radius: CGFloat = 16
        let height: CGFloat = 80
        let width: CGFloat = 360
        let imageWidth: CGFloat = 40
        let imageHeight: CGFloat = 40
        let numOfDecimals: Int = 2
        HStack {
            AsyncImage(url: NetworkManager.getImageURL(for: pokemon.id)) { image in
                image.resizable()}
            placeholder: {
                ProgressView()
            }
            .frame(width: imageWidth, height: imageHeight)
            VStack (alignment: .leading) {
                Text(pokemon.name)
                    .bold()
                    .font(.title2)
                HStack {
                    Image(systemName: "scalemass")
                    Text(pokemon.weight.formatted(.number.precision(.fractionLength(numOfDecimals))))
                    Image(systemName: "ruler")
                    Text(pokemon.height.formatted(.number.precision(.fractionLength(numOfDecimals))))
                }
            }
            Spacer()
            VStack {
                Text("id: \(pokemon.id)")
                Image(pokemon.captured ? "PokemonBall" : "")
                    .resizable()
                    .frame(width: imageWidth / 2, height: imageHeight / 2)
            }
        }
        .padding()
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: radius).fill(.white).shadow(color: .black, radius: shadowRadius))
    }
}

#Preview {
    let pokemon = Pokemon.standard
    PokemonListView(pokemon: pokemon)
}
