//
//  GameAssistanceView.swift
//  LionSpell
//
//  Created by LiasPub on 2/11/26.
//

import SwiftUI

struct GameAssistanceView: View {
    
    var text: String
    var number: Int
    var navigation: Bool
    var image: String
    
    var body: some View {
        
        GeometryReader { geo in
            
            let height: CGFloat = 50
            let width: CGFloat = geo.size.width * 0.9
            
            ZStack {
                HStack {
                    Image(systemName: image)
                    LionSpellTextView(text: text)
                    LionSpellTextView(text: "\(number)")
                    Spacer()
                    if navigation {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding(.horizontal, 40)
                .foregroundColor(.white)
                .font(.title2)
                .background(RoundedRectangle(cornerRadius: 16).fill(.gray.opacity(0.75)).frame(width: width, height: height))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    GameAssistanceView(text: "Points:", number: 4, navigation: false, image: "star")
}
