//
//  FourLetterView.swift
//  LionSpell
//
//  Created by LiasPub on 2/11/26.
//

import SwiftUI

struct FiveLetterView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    
    var body: some View {
        ZStack {
            ColoredPolygonView(sides: 5, color: .yellow, letter: manager.letters[0].character, required: true)
            ColoredPolygonView(sides: 5, color: .gray, letter: manager.letters[1].character, required: false)
                .offset(x: 37, y: 37)
            ColoredPolygonView(sides: 5, color: .gray, letter: manager.letters[2].character, required: false)
                .offset(x: 37, y: -37)
            ColoredPolygonView(sides: 5, color: .gray, letter: manager.letters[3].character, required: false)
                .offset(x: -37, y: -37)
            ColoredPolygonView(sides: 5, color: .gray, letter: manager.letters[4].character, required: false)
                .offset(x: -37, y: 37)
        }
    }
}

#Preview {
    FiveLetterView()
        .environment(LionSpellViewModel())
}
