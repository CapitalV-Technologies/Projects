//
//  StatsView.swift
//  Pokedex
//
//  Created by LiasPub on 4/2/26.
//

import SwiftUI

struct StatsView: View {
    var pokemon: Pokemon
    var width: CGFloat
    var body: some View {
        let height: CGFloat = 110
        let cornerRadius: CGFloat = 16
        let shadow: CGFloat = 5
        let padding: CGFloat = 10
        let numOfDecimals: Int = 2
        VStack (alignment: .leading) {
            Text("Stats:")
                .bold()
                .font(.title2)
                .padding(padding)
            HStack {
                Spacer()
                Image(systemName: "scalemass")
                    .font(.title)
                    .foregroundStyle(.yellow)
                VStack {
                    Text("WEIGHT")
                        .font(.subheadline)
                    Text((pokemon.weight.formatted(.number.precision(.fractionLength(numOfDecimals)))) + " m")
                        .bold()
                }
                Spacer()
                Image(systemName: "ruler")
                    .font(.title)
                    .foregroundStyle(.blue)
                VStack {
                    Text("HEIGHT")
                        .font(.subheadline)
                    Text((pokemon.height.formatted(.number.precision(.fractionLength(numOfDecimals)))) + " Kg")
                        .bold()
                }
                Spacer()
            }
            .padding(.horizontal, padding)
        }
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: cornerRadius).fill(.white).shadow(radius: shadow))
        .padding(.horizontal, padding / 2)
    }
}

#Preview {
    StatsView(pokemon: Pokemon.standard, width: 360)
}
