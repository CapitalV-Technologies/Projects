//
//  Text.swift
//  LionSpell
//
//  Created by LiasPub on 1/28/26.
//

import SwiftUI

struct LionSpellTextView: View {
    var text: String
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .fontDesign(.serif)
    }
}
