//
//  Score.swift
//  LionSpell
//
//  Created by LiasPub on 1/23/26.
//

import SwiftUI

struct ScoreView: View {
    @Environment(LionSpellViewModel.self) var manager: LionSpellViewModel
    var body: some View {
        Text("\(String(manager.totalPoints))")
            .fontWeight(.heavy)
            .font(.title)
            .padding()
            .background(Color.gray)
            .foregroundColor(.yellow)
            .clipShape(.capsule)
            .shadow(color: .yellow, radius: 8)
    }
}
