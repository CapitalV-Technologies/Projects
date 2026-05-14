//
//  PentominoShapeView.swift
//  Pentominoes
//
//  Created by LiasPub on 2/23/26.
//

import SwiftUI

struct PentominoShapeView: Shape {
    var pentomino: PentominoOutline
    func path(in rect: CGRect) -> Path {
        var path = Path ()
        let scaleX = rect.width / CGFloat(pentomino.size.width)
        let scaleY = rect.height / CGFloat(pentomino.size.height)
        let first = pentomino.outline[0]
        path.move(to: CGPoint(x: CGFloat(first.x) * scaleX , y: CGFloat(first.y) * scaleY))
        for point in pentomino.outline {
                path.addLine(to: CGPoint(x: CGFloat(point.x) * scaleX , y: CGFloat(point.y) * scaleY))
            }
        return path
    }
}

