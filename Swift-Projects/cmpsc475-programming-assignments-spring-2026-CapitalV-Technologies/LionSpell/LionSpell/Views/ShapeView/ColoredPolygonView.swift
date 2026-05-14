//
//  ColoredPolygonView.swift
//  LionSpell
//
//  Created by LiasPub on 2/11/26.
//

import SwiftUI

struct ColoredPolygonView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    var sides: Int
    var color: Color
    var letter: Character
    var required: Bool
    var rotation : Double?
    var body: some View {
        let height: CGFloat = 70
        let width: CGFloat = 70
        
        Button {
            manager.currentWord.append(Letter(character: letter, requiredLetter: required))
            manager.checkWord()
        } label: {
            ZStack {
                PolygonView(sides: sides)
                    .fill(color)
                    .frame(width: width, height: height)
                LionSpellTextView(text: String(letter))
                    .font(.title)
                    .rotationEffect(.degrees(rotation ?? 0))
                
            }
        }
    }
}

#Preview {
    ColoredPolygonView(sides: 4, color: .gray, letter: "T", required: true)
        .environment(LionSpellViewModel())
}
