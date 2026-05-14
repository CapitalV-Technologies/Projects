//
//  GameButtons.swift
//  Pentominoes
//
//  Created by LiasPub on 2/19/26.
//

import SwiftUI

struct GameButtonsView: View {
    // For Final Project, Want it to be UI heavy. Interesting and nothing easy
    var text: String
    var color: Color
    var function: () -> Void
    var body: some View {
        let width: CGFloat = 150
        let height: CGFloat = 90
        let radius: CGFloat = 16
        Button {
            function()
        } label: {
            Text(text)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: radius).fill(color).frame(width: width, height: height))
                .shadow(radius: radius)

        }
    }
}
