//
//  StringView.swift
//  LionSpell
//
//  Created by LiasPub on 2/9/26.
//

import SwiftUI

struct StringView: View {
    var word: String
    var body: some View {
        let width: CGFloat = 125
        let height: CGFloat = 60
            Text(word)
                .frame(width: width, height: height)
                .background(.gray.opacity(0.7))
                .shadow(radius: 7)
                .foregroundColor(.white)
    }
}

#Preview {
    StringView(word: "String")
}
