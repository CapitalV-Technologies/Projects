//
//  AllWords.swift
//  Lion Spell
//
//  Created by Alfares, Nader on 12/20/25.
//
import Foundation


struct Words: Codable {
    let englishWords: [String]
    let germanWords: [String]
    let frenchWords: [String]
    let italianWords: [String]
    // For assignment 2, have different variables for each language
    // Then decode each of the different languages
    
    enum CodingKeys: String, CodingKey {
        case englishWords
        case germanWords
        case frenchWords
        case italianWords // Setting whatever the JSON equivalent is for this variable
    }
    
    init() {
        guard
            let url = Bundle.main.url(forResource: "Words", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode(Words.self, from: data)
        else {
            // Safe fallback (no crash)
            // This shouldn't happen
            self.englishWords = []
            self.frenchWords = []
            self.germanWords = []
            self.italianWords = []
            return
        }
        
        self.englishWords = decoded.englishWords
        self.frenchWords = decoded.frenchWords
        self.italianWords = decoded.italianWords
        self.germanWords = decoded.germanWords
    }
    
    static let allWords = Words()
    
}





