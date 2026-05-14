//
//  Letters.swift
//  LionSpell
//
//  Created by LiasPub on 1/23/26.
//

import Foundation

struct Letter: Identifiable {
    var id = UUID()
    var character: Character
    var requiredLetter: Bool
}
