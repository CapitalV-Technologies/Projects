//
//  GridShapeView.swift
//  Pentominoes
//
//  Created by LiasPub on 2/23/26.
//

import SwiftUI

struct GridShapeView: Shape {
    var rows: Int
    var columns: Int
    func path(in rect: CGRect) -> Path {
        var path = Path ()
        // Draw Rows
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        for i in 0..<rows{
            
            
            path.addLine(to: CGPoint(x: rect.maxX , y: rect.minY + (rect.height / (CGFloat(rows)) * CGFloat(i))))
            
            
            
            path.move(to: CGPoint(x: rect.minX, y: rect.minY + (rect.height / (CGFloat(rows)) * CGFloat(i + 1))))
            }
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        // Draw Columns
        for i in 0..<columns{
            
            
            path.addLine(to: CGPoint(x: (rect.minX + (rect.width / (CGFloat(columns))) * CGFloat(i)), y: rect.maxY))
            
            
            
            path.move(to: CGPoint(x: (rect.minX + (rect.width / (CGFloat(columns)) * CGFloat(i + 1))), y: rect.minY))
            }
        // Draw last two line
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        return path
    }
}

#Preview {
    GridShapeView(rows: 10, columns: 10)
        .stroke(.black, lineWidth: 2)
        .frame(width: 560, height: 560)
        
}
