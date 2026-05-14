//
//  Preferences.swift
//  LionSpell
//
//  Created by LiasPub on 2/4/26.
//

import Foundation

enum Language: String, CaseIterable, Identifiable {
    case english = "English"
    case german = "German"
    case french = "French"
    case italian = "Italian"
    
    var id : String { rawValue }
    
    var whichLanguage: [String] {
        switch self {
        case .english: return Words.allWords.englishWords
        case .german: return Words.allWords.germanWords
        case .french: return Words.allWords.frenchWords
        case .italian: return Words.allWords.italianWords
        }
    }
}

enum Difficulty: String, CaseIterable, Identifiable {
    case five = "5 Letters"
    case six = "6 Letters"
    case seven = "7 Letters"
    
    var id : String { rawValue }
    
    var number: Int {
        switch self {
            case .five: return 5
            case .six: return 6
            case .seven: return 7
        }
    }
}

struct Preferences: Hashable {
    var language: Language = .english
    var difficulty: Difficulty = .five
}
