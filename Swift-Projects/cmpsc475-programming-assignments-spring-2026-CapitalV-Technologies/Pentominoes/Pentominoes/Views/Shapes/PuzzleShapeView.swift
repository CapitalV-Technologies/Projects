//
//  PuzzleShapeView.swift
//  Pentominoes
//
//  Created by LiasPub on 2/24/26.
//

import SwiftUI

struct PuzzleShapeView: Shape {
    var puzzle: PuzzleOutline
    func path(in rect: CGRect) -> Path {
        var path = Path ()
        let scaleX = rect.width / CGFloat(puzzle.size.width)
        let scaleY = rect.height / CGFloat(puzzle.size.height)
        for outline in puzzle.outlines {
            let first = outline[0]
            path.move(to: CGPoint(x: CGFloat(first.x) * scaleX , y: CGFloat(first.y) * scaleY))
            for point in outline {
                path.addLine(to: CGPoint(x: CGFloat(point.x) * scaleX , y: CGFloat(point.y) * scaleY))
            }
        }
        return path
    }
}
