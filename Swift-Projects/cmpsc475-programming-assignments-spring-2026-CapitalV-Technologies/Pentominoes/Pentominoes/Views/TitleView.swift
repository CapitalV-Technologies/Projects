//
//  TitleView.swift
//  Pentominoes
//
//  Created by LiasPub on 2/22/26.
//

import SwiftUI

struct TitleView: View {
    var text: String
    var body: some View {
        let radius: CGFloat = 16
        Text(text)
            .bold()
            .font(.largeTitle)
            .foregroundColor(.white)
            .shadow(color: .white, radius: radius)
    }
}

#Preview {
    TitleView(text: "PENTOMINOES")
}
