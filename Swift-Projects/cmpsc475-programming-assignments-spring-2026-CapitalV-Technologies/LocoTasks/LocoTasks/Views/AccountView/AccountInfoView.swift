//
//  AccountInfoView.swift
//  Pokedex
//
//  Created by LiasPub on 3/22/26.
//

import SwiftUI

struct AccountInfoView: View {
    var color: Color
    var label: String
    var information: String?
    var body: some View {
        let shadowRadius: CGFloat = 4
        let radius: CGFloat = 16
        let height: CGFloat = 50
        let width: CGFloat = 360
        HStack {
            Text(label)
                .foregroundColor(color)
                .bold()
                .font(.title3)
            Spacer()
            Text(information ?? "")
        }
        .padding()
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: radius).fill(.white).shadow(color: .black, radius: shadowRadius).frame(width: width, height: height))
    }
}

#Preview {
    AccountInfoView(color: .black, label: "Email:", information: "Hello")
}
