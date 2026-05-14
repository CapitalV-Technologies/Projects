//
//  WordViewswift.swift
//  LionSpell
//
//  Created by LiasPub on 1/24/26.
//

import SwiftUI

struct WordView: View {
    var word: Word
    var body: some View {
        let radius: CGFloat = 7
        Text(word.word)
                .padding()
                .background(.gray)
                .shadow(radius: radius)
                .foregroundColor(.white)
        }
    }
