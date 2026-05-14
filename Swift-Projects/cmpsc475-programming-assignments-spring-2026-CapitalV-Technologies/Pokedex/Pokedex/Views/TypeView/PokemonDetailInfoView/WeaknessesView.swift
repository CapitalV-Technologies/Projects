//
//  WeaknessesView.swift
//  Pokedex
//
//  Created by LiasPub on 4/2/26.
//

import SwiftUI

struct WeaknessesView: View {
    var pokemon: Pokemon
    var width: CGFloat
    var body: some View {
        let height: CGFloat = 120
        let cornerRadius: CGFloat = 16
        let shadow: CGFloat = 5
        let padding: CGFloat = 10
        VStack (alignment: .leading) {
            Text("Weaknesses:")
                .bold()
                .font(.title2)
                .padding(.horizontal, padding)
            ScrollView (.horizontal) {
                HStack {
                    ForEach(pokemon.weaknesses) {type in
                        SmallTypeView(type: type)
                    }
                }
                .padding(.horizontal, padding)
            }
            .frame(width: width, height: height / 3)
        }
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: cornerRadius).fill(.white).shadow(radius: shadow))
        .padding(.horizontal, padding / 2)
    }
}

#Preview {
    WeaknessesView(pokemon: Pokemon.standard, width: 360)
}
