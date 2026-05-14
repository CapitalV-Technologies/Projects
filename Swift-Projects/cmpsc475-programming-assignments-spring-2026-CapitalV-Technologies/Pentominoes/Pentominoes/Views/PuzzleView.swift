//
//  PuzzleView.swift
//  Pentominoes
//
//  Created by LiasPub on 2/25/26.
//

import SwiftUI

struct PuzzleView: View {
    var puzzle: PuzzleOutline
    @Environment(PentominoesViewModel.self) var manager: PentominoesViewModel
    var body: some View {
        let opacity: CGFloat = 0.7
        let lineWidth: CGFloat = 2
        let size: CGFloat = CGFloat(manager.blockSize)
        let width: CGFloat = CGFloat(puzzle.size.width) * size
        let height: CGFloat = CGFloat(puzzle.size.height) * size
            PuzzleShapeView(puzzle: puzzle)
            .fill(.gray.opacity(opacity), style: FillStyle(eoFill: true))
            .stroke(.black, lineWidth: lineWidth)
            .frame(width: width, height: height)
                   
    }
}
