//
//  LetterView.swift
//  LionSpell
//
//  Created by LiasPub on 2/11/26.
//

import SwiftUI

struct LetterPolygonView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    var body: some View {
        switch manager.preferences.difficulty {
        case .five:
            FiveLetterView()
        case .six:
            SixLetterView()
        case .seven:
            SevenLetterView()
        }
    }
}

#Preview {
    LetterPolygonView()
        .environment(LionSpellViewModel())
}
