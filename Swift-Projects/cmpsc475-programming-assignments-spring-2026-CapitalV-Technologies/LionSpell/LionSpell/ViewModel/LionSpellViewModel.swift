//
//  LionSpellViewModel.swift
//  LionSpell
//
//  Created by LiasPub on 1/23/26.
//

import Foundation
import SwiftUI


@Observable
class LionSpellViewModel {
    
    var lettersSet: Set<Character> = []
    var letters: [Letter] = []
    var currentWord: [Letter] = []
    var potentialWords: [String] = []
    var showSubmitButton: Bool = false
    var currentWordList: [Word] = []
    var totalPoints: Int = 0
    var totalWords: Int = 0
    
    var bonusPoints = 10
    
    var preferences: Preferences = Preferences() {
        didSet {
            self.startNewGame()
        }
    }

    init() {
        startNewGame()
    }
    
    func startNewGame() {
        // Find random word from given list
        let word = preferences.language.whichLanguage.randomElement()!
        // Reset Variables
        lettersSet = []
        letters.removeAll()
        currentWord = []
        potentialWords = []
        totalPoints = 0
        totalWords = 0
        showSubmitButton = false
        currentWordList = []
        // Find 5, 6, or 7 different letters from word
        for letter in word {
            lettersSet.insert(letter)
        }
        let length = lettersSet.count
        if (length < self.preferences.difficulty.number) {
               startNewGame()
        }
        else {
            // Add letters to list
            var char: Character
            var req: Character
            // Randomly select required letter (yet make it the first one)
            req = addLetters(required: true)
            char = addLetters(required: false)
            char = addLetters(required: false)
            char = addLetters(required: false)
            char = addLetters(required: false)
            if (self.preferences.difficulty.number == 5) {
                // Add fake letters so index is never out of bounds
                letters.append(Letter(character: "!", requiredLetter: false))
                letters.append(Letter(character: "!", requiredLetter: false))
            }
            if (self.preferences.difficulty.number == 6) {
                char = addLetters(required: false)
                letters.append(Letter(character: "!", requiredLetter: false))
            }
            if (self.preferences.difficulty.number == 7) {
                char = addLetters(required: false)
                char = addLetters(required: false)
            }
            findPotentialWords(required: req)
        }
    }
    
    //Computed Property
    var totalPointsPossible: Int {
        var points = 0
        // Update letters
        if (self.preferences.difficulty.number == 5) {
            // Add fake letters so index is never out of bounds
            letters.popLast()
            letters.popLast()
        }
        if (self.preferences.difficulty.number == 6) {
            // Add fake letters so index is never out of bounds
            letters.popLast()
        }
        for word in self.potentialWords {
            let count = word.count
            var bonus = true
            for letter in letters {
                if !word.contains(letter.character) {
                    bonus = false
                }
            }
            // Add points based on length of word
            if bonus {
                points += ((count - 3) + bonusPoints)
            } else {
                points += (count - 3)
            }
        }
        if (self.preferences.difficulty.number == 5) {
            // Add fake letters so index is never out of bounds
            letters.append(Letter(character: "!", requiredLetter: false))
            letters.append(Letter(character: "!", requiredLetter: false))
        }
        if (self.preferences.difficulty.number == 6) {
            // Add fake letters so index is never out of bounds
            letters.append(Letter(character: "!", requiredLetter: false))
        }
        return points
    }
    
    //Computed Property
    var totalPangramsPossible: (Int, [String]) {
        var total = 0
        var pangrams: [String] = []
        if (self.preferences.difficulty.number == 5) {
            // Add fake letters so index is never out of bounds
            letters.popLast()
            letters.popLast()
        }
        if (self.preferences.difficulty.number == 6) {
            // Add fake letters so index is never out of bounds
            letters.popLast()
        }
        for word in self.potentialWords {
            var isPangram = true
            for letter in letters {
                if !word.contains(letter.character) {
                    isPangram = false
                }
            }
            if isPangram {
                total += 1
                pangrams.append(word)
            }
        }
        if (self.preferences.difficulty.number == 5) {
            // Add fake letters so index is never out of bounds
            letters.append(Letter(character: "!", requiredLetter: false))
            letters.append(Letter(character: "!", requiredLetter: false))
        }
        if (self.preferences.difficulty.number == 6) {
            // Add fake letters so index is never out of bounds
            letters.append(Letter(character: "!", requiredLetter: false))
        }
        return (total, pangrams)
    }
    
    //Computed Property
    var findWordsByLength: [Int: [(Character, Int)]] {
        // return a dictionary with length as key, and a tuple with letter and number
        var dict = [Int: [(Character, Int)]]()
        for word in self.potentialWords {
            let length = word.count
            let letter = word[word.startIndex]
            if var array = dict[length] {
                var found = false
                for i in 0..<array.count {
                    if letter == array[i].0 {
                        array[i].1 += 1
                        dict[length] = array
                        found = true
                        break
                    }
                }
                if !found {
                    if var array = dict[length] {
                        array.append((letter, 1))
                        dict[length] = array
                    }
                }
            } else {
                dict[length] = [(letter, 1)]
            }
        }
        return dict
    }
    
    func shuffleLetters() {
        // Shuffle Letters
        // Preserve Required Letter being in the middle
        let letter: Letter = letters.remove(at: 0)
        if (self.preferences.difficulty.number == 7) {
            letters.shuffle()
        }
        if (self.preferences.difficulty.number == 6) {
            letters.popLast()
            letters.shuffle()
            letters.append(Letter(character: "!", requiredLetter: false))
        }
        if (self.preferences.difficulty.number == 5) {
            letters.popLast()
            letters.popLast()
            letters.shuffle()
            letters.append(Letter(character: "!", requiredLetter: false))
            letters.append(Letter(character: "!", requiredLetter: false))
        }
        letters.insert(letter, at: 0)
    }
    
    func deleteLetter() {
        // Delete last letter in list
        currentWord.popLast()
        // ReCheck if there is a current word after deletion
        self.checkWord()
    }
    
    private func findPotentialWords(required: Character) {
        // Re-add letters to lettersSet
        lettersSet.removeAll()
        for letter in letters {
            lettersSet.insert(letter.character)
        }
        // Remove fake letter if exists
        lettersSet.remove("!")
        // Find all potential words with required letter
        potentialWords = preferences.language.whichLanguage.filter { word in
            // Check if word is less than 4 letters
            if word.count < 3 {return false}
            // Check for required letter
            if !word.contains(required) {return false}
            // Check for any words with different letters
            if !Set(word).isSubset(of: lettersSet) {
                return false
            }
        return true}
        if !self.potentialWords.contains(where: {$0.count == 5 }) {
                  self.startNewGame()
                }
    }
    
    private func addLetters(required: Bool) -> Character {
        var character: Character
        // Randomly select character from Set
        character = lettersSet.randomElement()!
        // Add Letter object to list of letters
        letters.append(Letter(character: character, requiredLetter: required))
        lettersSet.remove(character)
        return character
        
    }
    
    private func getCurrentWord() -> (String, Int) {
        // Get User's current built word
        var currentWord: String = ""
        for letter in self.currentWord {
                currentWord.append(letter.character)
        }
        let length = currentWord.count
        return (currentWord, length)
    }
    
    func checkWord() {
        // Check if user's current word is in potentialWords list
        let data = getCurrentWord()
        let currentWord = data.0
        var add = true
        if potentialWords.contains(currentWord) {
            for word in currentWordList {
                // Check if word has already been found
                if (word.word == currentWord) {
                    add = false
                }
            }
                if add {
                    // If valid word, enable submit button
                    self.showSubmitButton = true
                    return
                }
        }
        // Keep disabled/disable if invalid word
        self.showSubmitButton = false
    }
    
    func addWord() {
        // Add found word to list of found words
        let data = getCurrentWord()
        let currentWord = data.0
        let length = data.1
        currentWordList.append(Word(word: currentWord))
        // Check for 10 point bonus
        var bonus = true
        for i in 0..<self.preferences.difficulty.number {
            if !currentWord.contains(letters[i].character) {
                bonus = false
            }
        }
        // Add points based on length of word
        if bonus {
            self.totalPoints += ((length - 3) + bonusPoints)
        } else {
            self.totalPoints += (length - 3)
        }
        totalWords += 1
        self.currentWord = []
        self.showSubmitButton = false
    }
}
