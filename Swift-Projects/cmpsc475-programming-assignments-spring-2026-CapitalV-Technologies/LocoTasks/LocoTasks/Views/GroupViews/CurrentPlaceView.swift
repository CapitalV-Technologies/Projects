//
//  CurrentPlaceView.swift
//  LocoTasks
//
//  Created by LiasPub on 4/16/26.
//

import SwiftUI

struct CurrentPlaceView: View {
    var place: Int
    var body: some View {
        let width: CGFloat = 50
        let height: CGFloat = 50
        let lineWidth: CGFloat = 2
        var backgroundColor: Color {
            if (place == 1) {
                return .yellow
            } else if (place == 2) {
                return .gray
            } else if (place == 3){
                return .brown
            } else {
                return .clear
            }
        }
        Text("\(String(place))")
            .font(.title)
            .fontWeight(.heavy)
            .padding()
            .background(Circle().fill(backgroundColor).stroke(.black, lineWidth: lineWidth).frame(width: width, height: height))
            .foregroundColor(.black)
    }
}

#Preview {
    CurrentPlaceView(place: 1)
}
