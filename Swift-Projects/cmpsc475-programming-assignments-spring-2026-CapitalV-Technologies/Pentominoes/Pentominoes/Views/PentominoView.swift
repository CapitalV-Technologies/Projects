//
//  PentominoShapeView.swift
//  Pentominoes
//
//  Created by LiasPub on 2/23/26.
//

import SwiftUI

struct PentominoView: View {
    var pentomino: PentominoOutline
    @Environment(PentominoesViewModel.self) var manager: PentominoesViewModel
    var body: some View {
        let lineWidth: CGFloat = 2
        let size: CGFloat = CGFloat(manager.blockSize)
        let width: CGFloat = CGFloat(pentomino.size.width) * size
        let height: CGFloat = CGFloat(pentomino.size.height) * size
        PentominoShapeView(pentomino: pentomino)
            .fill(Color(pentomino: pentomino))
                .stroke(.black, lineWidth: lineWidth)
                .overlay(GridShapeView(rows: pentomino.size.height, columns: pentomino.size.width)
                    .stroke(.black, lineWidth: lineWidth)
                    .clipShape(PentominoShapeView(pentomino: pentomino)))
                .frame(width: width, height: height)
    }
}

