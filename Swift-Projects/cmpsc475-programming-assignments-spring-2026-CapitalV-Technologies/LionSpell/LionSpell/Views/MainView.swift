//
//  MainView.swift
//  LionSpell
//
//  Created by LiasPub on 1/21/26.
//

import SwiftUI

//Completed
struct MainView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    @State var showSettingsSheetView: Bool = false
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            VStack {
                HStack {
                    VStack (alignment: .leading) {
                        LionSpellTextView(text: "LION SPELL")
                            .font(.title2)
                        LionSpellTextView(text: "Nittany Word Challenge")
                    }
                    Spacer()
                    VStack {
                        ScoreView()
                        LionSpellTextView(text: "SCORE")
                    }
                }
                .padding()
                .padding()
                
                Spacer()
                VStack {
                    LetterScrollableView()
                    LionSpellTextView(text: "Select Letters!")
                        .font(.footnote)
                        .padding(.bottom)
                    WordScrollableView()
                    LionSpellTextView(text: "Words Found: \(manager.totalWords)")
                        .font(.footnote)
                }
                Spacer()
//                HStack {
//                    ForEach(manager.letters) { letter in
//                        LetterView(letter: letter.character, color: (letter.requiredLetter ? .yellow : .gray) , required: letter.requiredLetter)
//                    }
                //}
                Spacer()
                Spacer()
                LetterPolygonView()
                .font(.title)
                .padding(.vertical, 20)
                Spacer()
                Spacer()
                Spacer()
                HStack {
                    VStack {
                        GameButtonsView(function:  manager.deleteLetter, image: "delete.left")
                            .disabled(manager.currentWord.isEmpty ? true : false)
                            .opacity(manager.currentWord.isEmpty ? 0.2 : 1.0)
                        LionSpellTextView(text: "Delete")
                            .font(.footnote)
                    }
                    VStack {
                        GameButtonsView(function: manager.addWord, image: "checkmark")
                            .disabled((manager.showSubmitButton ? false : true))
                            .opacity((manager.showSubmitButton ? 1.0 : 0.2))
                        LionSpellTextView(text: "Submit")
                            .font(.footnote)
                    }
                }
                Spacer()
                HStack {
                    VStack {
                        GameButtonsView(function:  manager.shuffleLetters, image: "shuffle")
                        LionSpellTextView(text: "Shuffle")
                            .font(.footnote)
                    }
                    Spacer()
                    VStack {
                        GameButtonsView(function: manager.startNewGame, image: "arrow.trianglehead.clockwise")
                        LionSpellTextView(text: "New Game")
                            .font(.footnote)
                    }
                    VStack {
                        GameButtonsView(function: {showSettingsSheetView.toggle()},
                                             image: "gearshape")
                        LionSpellTextView(text: "Settings")
                            .font(.footnote)
                    }
                    
                }
                .padding()
                .sheet(isPresented: $showSettingsSheetView) {
                    SettingsSheetView()
                }
            }
        }
    }
    
    // Stole From MindFlip App for color.
    let backgroundColor : LinearGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(.blue),
                Color(red: 0.36, green: 0.24, blue: 0.66)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
}


#Preview {
    MainView()
        .environment(LionSpellViewModel())
}
