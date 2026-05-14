//
//  AccountButtonView.swift
//  LocoTasks
//
//  Created by LiasPub on 4/12/26.
//

import SwiftUI

struct AccountButtonView: View {
    var body: some View {
        let width: CGFloat = 360
        let height: CGFloat = 60
        let radius: CGFloat = 16
        NavigationLink {
            AccountView()
        } label: {
            Text("Settings")
                .bold()
                .foregroundColor(.white)
                .font(.title2)
                .frame(width: width, height: height)
                .background(RoundedRectangle(cornerRadius: radius).fill(Color.pennStateLightBlue))
        }
    }
}

#Preview {
    AccountButtonView()
}
