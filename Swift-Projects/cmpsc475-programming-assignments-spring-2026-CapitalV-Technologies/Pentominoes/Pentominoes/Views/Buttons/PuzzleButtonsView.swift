//
//  PuzzleButtons.swift
//  Pentominoes
//
//  Created by LiasPub on 2/22/26.
//

import SwiftUI

struct PuzzleButtonsView: View {
    @Environment(PentominoesViewModel.self) var manager: PentominoesViewModel
    var image: String
    var index: Int
    var body: some View {
        let width: CGFloat = 150
        let height: CGFloat = 150
        let radius: CGFloat = 16
        Button {
            if index == -1 {
                manager.showPuzzle = false
            } else {
                manager.currentPuzzle = manager.puzzleOutlines[index]
                manager.showPuzzle = true
                manager.puzzleIndex = index
            }
        } label: {
            Image(image)
                .resizable()
                .frame(width: width, height: height)
                .shadow(radius: radius)

        }
    }
}
