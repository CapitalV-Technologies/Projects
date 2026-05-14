//
//  MembersView.swift
//  LocoTasks
//
//  Created by LiasPub on 4/16/26.
//

import SwiftUI

struct LeaderBoardMembersView: View {
    var user: String
    var totalPoints: Int
    var place: Int
    var body: some View {
        let shadowRadius: CGFloat = 4
        let radius: CGFloat = 16
        let height: CGFloat = 80
        let width: CGFloat = 360
        HStack {
            VStack (alignment: .leading) {
                Text(user)
                    .bold()
                    .font(.title2)
                Text("Total Points: \(totalPoints)")
                    .font(.subheadline)
            }
            Spacer()
            CurrentPlaceView(place: place)
            
        }
        .padding()
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: radius).fill(.white).shadow(color: .black, radius: shadowRadius))
    }
}

#Preview {
    LeaderBoardMembersView(user: "User", totalPoints: 4, place: 1)
}
