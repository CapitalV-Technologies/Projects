//
//  GameButtons.swift
//  LionSpell
//
//  Created by LiasPub on 1/23/26.
//

import SwiftUI

struct GameButtonsView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    var function: () -> Void
    var image: String
    var body: some View {
        let radius: CGFloat = 7
        Button {
            function()
        } label:
        {
            Image(systemName: image)
                .padding()
                .background(Color.gray)
                .shadow(radius: radius)
                .foregroundColor(.white)
                .clipShape(.circle)
                .colorScheme(.dark)
        }
        
        .shadow(radius: radius)
    }
}
