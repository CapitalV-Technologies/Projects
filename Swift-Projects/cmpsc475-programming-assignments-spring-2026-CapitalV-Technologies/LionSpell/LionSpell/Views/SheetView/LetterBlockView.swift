//
//  LetterBlockView.swift
//  LionSpell
//
//  Created by LiasPub on 2/10/26.
//

import SwiftUI

struct LetterBlockView: View {
    var letter: Character
    var number: Int
    var body: some View {
        VStack {
            LionSpellTextView(text: String(letter))
                .font(.title)
            Text("\(number)")
                .foregroundColor(.yellow)
        }
        .background(RoundedRectangle (cornerRadius: 15)
            .fill(.gray.opacity (0.7))
            .frame(width: 80, height: 70))
    }
}

#Preview {
    LetterBlockView(letter: "T", number: 40)
}
