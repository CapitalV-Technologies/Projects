//
//  LettersGridView.swift
//  LionSpell
//
//  Created by LiasPub on 2/13/26.
//

import SwiftUI

struct LettersGridView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    var words: [(Character, Int)]
    
    var body: some View {
        let number: Int = words.count
        ZStack {
            backgroundColor.ignoresSafeArea()
            VStack (spacing: 5) {
                ScrollView {
                    let numberOfRows = Int(ceil(Double(number) / 3.0))
                    ForEach(0..<numberOfRows, id:\.self) { row in
                        HStack {
                            ForEach(0..<3, id:\.self) { col in
                                let index = row * 3 + col
                                if (index < number) {
                                        LetterBlockView(letter: words[index].0, number: words[index].1)
                                }
                            }
                            .padding()
                            .padding()
                        }
                    }
                }
            }
            .padding()
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
