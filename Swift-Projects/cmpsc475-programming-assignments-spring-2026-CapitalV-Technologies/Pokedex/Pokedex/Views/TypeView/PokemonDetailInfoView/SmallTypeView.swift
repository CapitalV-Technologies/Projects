//
//  SmallTypeView.swift
//  Pokedex
//
//  Created by LiasPub on 4/1/26.
//

import SwiftUI

struct SmallTypeView: View {
    var type: PokemonType
    var body: some View {
        let cornerRadius: CGFloat = 16
        let width: CGFloat = 80
        let height: CGFloat = 40
        Text(type.id)
            .foregroundStyle(.white)
            .bold()
            .frame(width: width, height: height)
            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color(pokemonType: type)))
    }
}
