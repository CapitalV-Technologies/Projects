//
//  Letter.swift
//  LionSpell
//
//  Created by LiasPub on 1/23/26.
//

import SwiftUI

struct LettersView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    var letter: Character
    var color: Color
    var required: Bool
    var body: some View {
        let radius: CGFloat = 7
        Button {
            manager.currentWord.append(Letter(character: letter, requiredLetter: required))
            manager.checkWord()
        } label:
        {
            Text("\(String(letter))")
                .padding()
                .background(color)
                .shadow(radius: radius)
                .foregroundColor(.white)
                
        }
        
        .shadow(radius: radius)
    }
}
