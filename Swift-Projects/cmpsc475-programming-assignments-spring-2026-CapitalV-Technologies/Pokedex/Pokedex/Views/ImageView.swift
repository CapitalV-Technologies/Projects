//
//  ImageView.swift
//  Pokedex
//
//  Created by LiasPub on 4/2/26.
//

import SwiftUI

struct ImageView: View {
    var pokemon: Pokemon
    var imageWidth: CGFloat
    var imageHeight: CGFloat
    var width: CGFloat
    var height: CGFloat
    let cornerRadius: CGFloat = 16
    
    var body: some View {
        VStack {
            AsyncImage(url: NetworkManager.getImageURL(for: pokemon.id)) { image in
                image.resizable()}
            placeholder: {
                Image(systemName: "questionmark")
                    .foregroundStyle(.white)
            }
            .frame(width: imageWidth, height: imageHeight)
            Text(pokemon.name)
                .foregroundStyle(.white)
                .bold()
                .font(.title3)
            Text("#\(pokemon.id)")
                .foregroundStyle(.white)
            
        }
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(pokemon: pokemon)))
    }
}

#Preview {
    ImageView(pokemon: Pokemon.standard, imageWidth: 60, imageHeight: 60, width: 300, height: 400)
}
