//
//  WordScrollable.swift
//  LionSpell
//
//  Created by LiasPub on 1/24/26.
//

import SwiftUI

struct WordScrollableView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    var body: some View {
        let height: CGFloat = 60
        let width: CGFloat = .infinity
        ScrollView(.horizontal) {
            HStack {
                ForEach(manager.currentWordList) {word in
                    WordView(word: word)
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
