//
//  PentominoesViewModel.swift
//  Pentominoes
//
//  Created by LiasPub on 2/22/26.
//

import Foundation

@Observable
class PentominoesViewModel {
    
    var pentominoPieces: [Piece] = []
    var puzzleOutlines: [PuzzleOutline] = []

    var pentominoOutline: [PentominoOutline] = []
    
    var solutions: Solutions?
    
    var currentPuzzle: PuzzleOutline?
    var blockSize: Int = 40
    var gameBoardSize: Int = 14
    
    var frame: Int = 0

    var showPuzzle: Bool = false
    var puzzleIndex: Int = 0
    
    var positionYOffset: Int = 150
    var positionXOffset: Int = 10
    
    init() {
        frame = self.blockSize * self.gameBoardSize
        loadFromJSONPentomino(filename: "PentominoOutlines")
        loadFromJSONPuzzle(filename: "PuzzleOutlines")
        loadFromJSONSolutions(filename: "Solutions")
        setInitalPositions()
        currentPuzzle = puzzleOutlines[0]
    }
    
    func solveSolution() {
        let solution = self.solutions![self.puzzleOutlines[self.puzzleIndex].name]
        for i in 0..<pentominoPieces.count {
            let position = solution![pentominoPieces[i].outline.name]
            pentominoPieces[i].position.orientation = position!.orientation
            pentominoPieces[i].position.x = position!.x * self.blockSize
            pentominoPieces[i].position.y = position!.y * self.blockSize
            
        }
    }
    
    
    func checkIfCorrect(piece: Piece) -> Bool {
        let name = piece.outline.name
        let solution = self.solutions![self.puzzleOutlines[self.puzzleIndex].name]
        let position = solution![name]
        if (((position!.x * self.blockSize) == piece.position.x) && ((position!.y * self.blockSize) == piece.position.y) && (position!.orientation == piece.position.orientation)){
            return true
        }
        return false
    }
    //
    
    var puzzleCenter: Int {
        return frame / 2
    }
    
    func loadFromJSONSolutions(filename: String) {
        guard
            let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("JSON file not found in bundle")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            solutions = try decoder.decode(Solutions.self, from: data)
        }
        catch {
            print("Failed to load JSON: \(error)")
        }
    }
    
    
    func loadFromJSONPentomino(filename: String) {
        guard
            let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("JSON file not found in bundle")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            pentominoOutline = try decoder.decode([PentominoOutline].self, from: data)
        }
        catch {
            print("Failed to load JSON: \(error)")
        }
    }
    
    func loadFromJSONPuzzle(filename: String) {
        guard
            let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("JSON file not found in bundle")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            puzzleOutlines = try decoder.decode([PuzzleOutline].self, from: data)
        }
        catch {
            print("Failed to load JSON: \(error)")
        }
    }
    
    func resetPositions() {
        for i in 0..<pentominoPieces.count {
            let (x, y) = setInitialPositionsHelper(i: i)
            pentominoPieces[i].position.x = x
            pentominoPieces[i].position.y = y
            pentominoPieces[i].position.orientation = .up
        }
    }
    
    func setInitalPositions () {
        for i in 0..<pentominoOutline.count {
            let position: Position = Position(x: setInitialPositionsHelper(i:i).0, y: setInitialPositionsHelper(i:i).1)
            let piece: Piece = Piece(position: position, outline: pentominoOutline[i])
            pentominoPieces.append(piece)
        }
    }
    
    func setInitialPositionsHelper(i: Int) -> (Int, Int) {
        if i < 4 {
            return ((i * blockSize * (blockSize / 10) + positionXOffset), (self.blockSize * self.gameBoardSize) + positionYOffset)
        } else if i < 8 {
            return (((i - 4) * blockSize * (blockSize / 10) + positionXOffset), (self.blockSize * self.gameBoardSize) + positionYOffset + positionYOffset)
        } else {
            return (((i - 8) * blockSize * (blockSize / 10) + positionXOffset), (self.blockSize * self.gameBoardSize) + positionYOffset + positionYOffset + positionYOffset)
        }
    }
}
