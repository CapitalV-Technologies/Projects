//
//  SquareButtonView.swift
//  LocoTasks
//
//  Created by LiasPub on 4/12/26.
//

import SwiftUI

struct SquareView<Content: View>: View {
    @Environment(AuthManager.self) var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    var title: String
    var view: Content
    var body: some View {
        let cornerRadius: CGFloat = 16
        let padding: CGFloat = 10
        let side: CGFloat = 140
        NavigationLink {
            view
        } label: {
            VStack (spacing: padding){
                Text(title)
                Image(systemName: "arrow.right")
            }
            .foregroundStyle(.white)
            .bold()
            .font(.title)
            .frame(width: side, height: side)
            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.pennStateLightBlue))
        }
    }
}
