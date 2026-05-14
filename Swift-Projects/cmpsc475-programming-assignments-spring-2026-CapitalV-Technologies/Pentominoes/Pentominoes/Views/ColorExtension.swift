//
//  ColorExtension.swift
//  Pentominoes
//
//  Created by LiasPub on 2/25/26.
//

import Foundation
import SwiftUI

extension Color {
    
    init (pentomino: PentominoOutline) {
        
        switch pentomino.name {
            case "X": self = .red
            case "P": self = .green
            case "F": self = .blue
            case "W": self = .brown
            case "Z": self = .yellow
            case "U": self = .orange
            case "V": self = .secondary
            case "T": self = .indigo
            case "L": self = .pink
            case "Y": self = .cyan
            case "N": self = .purple
            
        default:
            self = .mint
        }
    }
}
