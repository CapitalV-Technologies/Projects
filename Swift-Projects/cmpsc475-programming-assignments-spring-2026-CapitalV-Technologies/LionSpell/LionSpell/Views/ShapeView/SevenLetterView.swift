//
//  SixLetterView.swift
//  LionSpell
//
//  Created by LiasPub on 2/11/26.
//

import SwiftUI

struct SevenLetterView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    var body: some View {
        ZStack {
            ColoredPolygonView(sides: 7, color: .yellow, letter: manager.letters[0].character, required: true)
            ColoredPolygonView(sides: 7, color: .gray, letter: manager.letters[1].character, required: false)
                .offset(x: 57, y: 37)
            ColoredPolygonView(sides: 7, color: .gray, letter: manager.letters[2].character, required: false)
               .offset(x: 57, y: -37)
            ColoredPolygonView(sides: 7, color: .gray, letter: manager.letters[3].character, required: false)
                .offset(x: 0, y: -73)
            ColoredPolygonView(sides: 7, color: .gray, letter: manager.letters[4].character, required: false)
                .offset(x: -57, y: -37)
            ColoredPolygonView(sides: 7, color: .gray, letter: manager.letters[5].character, required: false)
                .offset(x: -57, y: 37)
            ColoredPolygonView(sides: 7, color: .gray, letter: manager.letters[6].character, required: false)
                .offset(x: 0, y: 73)
        }    }
}

#Preview {
    SevenLetterView()
        .environment(LionSpellViewModel())
}
