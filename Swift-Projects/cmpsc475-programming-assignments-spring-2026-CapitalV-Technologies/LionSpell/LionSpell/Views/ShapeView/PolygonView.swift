//
//  Polygon.swift
//  LionSpell
//
//  Created by LiasPub on 2/9/26.
//

import SwiftUI

struct PolygonView: Shape {
//    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    var sides: Int
    func path(in rect: CGRect) -> Path {
        if (sides == 5) {
            // Did this by myself
            var path = Path()
            path.move(to: CGPoint(x: rect.midX , y: rect.minY ))
            path.addLine(to: CGPoint(x: rect.maxX , y: rect.midY ))
            path.addLine(to: CGPoint(x: rect.midX , y: rect.maxY ))
            path.addLine(to: CGPoint(x: rect.minX , y: rect.midY ))
            path.closeSubpath()
            return path
        } else if (sides == 6){
            // NOTE: Used Chat GPT to estimate numbers to multiple by so that I could have even length sides
            var path = Path()
            path.move(to: CGPoint(x: rect.midX , y: rect.minY ))
            path.addLine(to: CGPoint(x: rect.maxX , y: rect.maxY * 0.42))
            path.addLine(to: CGPoint(x: rect.maxX * 0.81 , y: rect.maxY ))
            path.addLine(to: CGPoint(x: rect.maxX * 0.19, y: rect.maxY ))
            path.addLine(to: CGPoint(x: rect.minX , y: rect.maxY * 0.42))
            path.closeSubpath()
            return path
        } else {
            // NOTE: Used Chat GPT to estimate numbers to multiple by so that I could have even length sides
            var path = Path()
            path.move(to: CGPoint(x: rect.minX , y: rect.midY ))
            path.addLine(to: CGPoint(x: rect.maxX  * 0.22 , y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX  * 0.78, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX , y: rect.midY ))
            path.addLine(to: CGPoint(x: rect.maxX * 0.78 , y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX  * 0.22  , y: rect.maxY))
            path.closeSubpath()
            return path
        }
    }
}

#Preview {
    PolygonView(sides: 6)
        .frame(width: 300, height: 300)
}
