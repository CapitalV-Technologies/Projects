//
//  LettersView.swift
//  LionSpell
//
//  Created by LiasPub on 2/11/26.
//

import SwiftUI

struct SixLetterView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    var body: some View {
        ZStack {
            ColoredPolygonView(sides: 6, color: .yellow,
                               letter: manager.letters[0].character, required: true)
            ColoredPolygonView(sides: 6, color: .gray, letter: manager.letters[1].character, required: false, rotation: 32.5)
                .offset(x: 55, y: -25)
                .rotationEffect(.degrees(-32.5))
            ColoredPolygonView(sides: 6, color: .gray, letter: manager.letters[2].character, required: false, rotation: -32.5)
                .offset(x: -55, y: -25)
                .rotationEffect(.degrees(32.5))
            ColoredPolygonView(sides: 6, color: .gray, letter: manager.letters[3].character, required: false, rotation: -35)
                .offset(x: 62, y: -20)
                .rotationEffect(.degrees(35))
            ColoredPolygonView(sides: 6, color: .gray, letter: manager.letters[4].character, required: false, rotation: 35)
                .offset(x: -62, y: -20)
                .rotationEffect(.degrees(-35))
            ColoredPolygonView(sides: 6, color: .gray, letter: manager.letters[5].character, required: false, rotation: 40)
                .offset(x: -40, y: 49)
                .rotationEffect(.degrees(-40))
        }
    }
}

#Preview {
    SixLetterView()
        .environment(LionSpellViewModel())
}
