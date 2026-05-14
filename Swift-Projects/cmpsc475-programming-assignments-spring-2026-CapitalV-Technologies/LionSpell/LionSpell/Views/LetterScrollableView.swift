//
//  Scrollable.swift
//  LionSpell
//
//  Created by LiasPub on 1/23/26.
//

import SwiftUI

struct LetterScrollableView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    var body: some View {
        let height: CGFloat = 60
        let width: CGFloat = .infinity
            ScrollView(.horizontal) {
                HStack {
                    ForEach(manager.currentWord) {letter in
                        LettersView(letter: letter.character, color: (letter.requiredLetter ? .yellow : .gray), required: letter.requiredLetter)
                    }
                    .padding(.horizontal, 1)
                }
            }
            .frame(maxWidth: width, maxHeight: height)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.45)))
            .padding(.horizontal, 5)
    }
}
