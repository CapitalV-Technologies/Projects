//
//  MapButtonView.swift
//  LocoTasks
//
//  Created by LiasPub on 4/12/26.
//

import SwiftUI

struct MapButtonView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    var title: String
    var isImage: Bool
    var perform: () -> Void
    var body: some View {
        let cornerRadius: CGFloat = 10
        let padding: CGFloat = 5
        let width: CGFloat = 100
        let height: CGFloat = 50
        Button {
            perform()
        } label: {
            HStack (spacing: padding){
                if (isImage) {
                    Image(systemName: "pointer.arrow")
                }
                else {
                    Text(title)
                }
            }
            .foregroundStyle(.white)
            .font(.title3)
            .frame(width: width, height: height)
            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.pennStateNavy))
        }
    }
}
