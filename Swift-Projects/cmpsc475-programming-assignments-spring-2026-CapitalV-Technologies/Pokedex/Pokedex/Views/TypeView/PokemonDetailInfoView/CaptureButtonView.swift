//
//  CaptureButtonView.swift
//  Pokedex
//
//  Created by LiasPub on 4/1/26.
//

import SwiftUI

struct CaptureButtonView: View {
    // Dismiss Navigation view when clicked
    @Environment(\.dismiss) var dismiss
    @Environment(AuthManager.self) var authManager: AuthManager
    @Environment(NetworkManager.self) var networkManager: NetworkManager
    @Binding var allPokemon: [Pokemon]
    var pokemon: Pokemon
    var width: CGFloat
    @State var isLoading = false
    var body: some View {
        let height: CGFloat = 50
        let imageWidth: CGFloat = 20
        let imageHeight: CGFloat = 20
        let cornerRadius: CGFloat = 16
        let opacity = 0.5
        var captured = pokemon.captured
        Button {
            isLoading = true
            Task {
                if captured {
                    try await networkManager.setCapture(for: pokemon.id, isCaptured: false)
                } else {
                    try await networkManager.setCapture(for: pokemon.id, isCaptured: true)
                }
                // Retrieve all Pokemon again since we updated them
                // I know this is a lot of load on the server, but don't really care for this assignment
                // If I would actually use this app, I would try and only reset the pokemon that got updated from to reduce load on the server
                // But for time purposes, I am not gonna implement that.
                // And this works!
                do {
                    allPokemon = try await networkManager.getPokemonCollection()
                    isLoading = false
                    dismiss()
                } catch {
                    print("Error Loading Pokemon")
                }
            }
        } label: {
            if isLoading == false {
                HStack {
                    Image("PokemonBall")
                        .resizable()
                        .frame(width: imageWidth, height: imageHeight)
                    Text((captured ? "Release" : "Capture"))
                        .font(.title3)
                        .foregroundColor(.black)
                }
                .frame(width: width, height: height)
                .background(RoundedRectangle(cornerRadius: cornerRadius).fill(captured ? .red : .green).opacity(opacity))
            } else {
                ProgressView()
            }
        }
        .disabled(isLoading)
    }
}
