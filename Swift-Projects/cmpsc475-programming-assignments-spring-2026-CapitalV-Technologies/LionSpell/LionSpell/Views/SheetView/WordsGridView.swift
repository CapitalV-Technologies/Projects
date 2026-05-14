//
//  WordsGrid.swift
//  LionSpell
//
//  Created by LiasPub on 2/9/26.
//

import SwiftUI

struct WordsGridView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    var words: [String]
    
    var body: some View {
        let number: Int = words.count
        ZStack {
            backgroundColor.ignoresSafeArea()
            ScrollView {
                let numberOfRows = Int(ceil(Double(number) / 3.0))
                ForEach(0..<numberOfRows, id:\.self) { row in
                    HStack {
                        ForEach(0..<3, id:\.self) { col in
                            let index = row * 3 + col
                            if (index < number) {
                                        StringView(word: words[index])
                            }
                        }
                    }
                }
            }
        }
    }
    
    let backgroundColor : LinearGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(.blue),
                Color(red: 0.4, green: 0.4, blue: 0.66)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
}
