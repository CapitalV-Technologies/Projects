//
//  SettingsSheetView.swift
//  LionSpell
//
//  Created by LiasPub on 2/4/26.
//

import SwiftUI

struct SettingsSheetView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    @State private var isOn: Bool = false
    @State private var path = NavigationPath()
    
    
    // Use @Bindable
    var body: some View {
        NavigationStack (path: $path) {
            @Bindable var manager = manager
            ZStack{
                backgroundColor.ignoresSafeArea()
                ScrollView {
                    VStack {
                        LionSpellTextView(text: "Settings")
                            .font(.title)
                            .padding()
                        
                        
                        Picker("Language", selection: $manager.preferences.language) {
                            ForEach(Language.allCases) { language in
                                Text(language.rawValue).tag(language)
                            }
                        }
                        .pickerStyle(.segmented)
                        Picker("Difficulty", selection: $manager.preferences.difficulty) {
                            ForEach(Difficulty.allCases) { difficulty in
                                Text(difficulty.rawValue).tag(difficulty)
                            }
                        }
                        .pickerStyle(.segmented)
                        HStack {
                            Toggle("Show Hints", isOn: $isOn)
                                .foregroundColor(.white)
                                .padding(.horizontal, 100)
                                .tint(.yellow)
                        }
                        .background(RoundedRectangle(cornerRadius: 16).fill(.gray.opacity(0.8)).frame(width: 350, height: 35))
                        .padding()
                        
                        if isOn {
                            LionSpellTextView(text: "Game Assistance")
                                .font(.title)
                                .padding(.bottom, 35)
                            VStack (spacing: 50){
                                GameAssistanceView(text: "Points Possible:", number: manager.totalPointsPossible, navigation: false, image: "star")
                                NavigationLink {
                                    WordsGridView(words: manager.potentialWords)
                                } label: {
                                    GameAssistanceView(text: "Words Possible:", number: (manager.potentialWords.count), navigation: true, image: "text.word.spacing")
                                }
                                NavigationLink {
                                    WordsGridView(words: manager.totalPangramsPossible.1)
                                } label: {
                                    GameAssistanceView(text: "Pangrams Possible:", number: manager.totalPangramsPossible.0, navigation: true, image: "rectangle.grid.2x2")
                                }
                                LionSpellTextView(text: "Words By Length")
                                    .font(.title)
                                let wordsBylength = manager.findWordsByLength
                                ForEach(wordsBylength.keys.sorted(), id: \.self) {wordLength in
                                    NavigationLink {
                                        if let value = wordsBylength[wordLength] {
                                            LettersGridView(words: value)
                                        }
                                    } label: {
                                        GameAssistanceView(text: "Length: ", number: wordLength, navigation: true, image: "ruler.fill")
                                    }
                                }
                                
                            }
                        }
                    }
                    .foregroundColor(.gray)
                    .padding(.vertical, 20)
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

#Preview {
    SettingsSheetView()
        .environment(LionSpellViewModel())
}
