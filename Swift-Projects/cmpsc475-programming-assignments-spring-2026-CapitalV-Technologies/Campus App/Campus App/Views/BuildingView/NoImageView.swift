//
//  NoImageView.swift
//  Campus App
//
//  Created by LiasPub on 3/7/26.
//

import SwiftUI

struct NoImageView: View {
    var width: CGFloat
    var height: CGFloat
    var radius: CGFloat
    var body: some View {
        let size: CGFloat = 80
        let opacity = 0.5
        VStack {
            Image(systemName: "building.2.fill")
                .font(.custom( "", size: size))
            Text("No Image Available")
                .font(.title)
        }
        .background(RoundedRectangle(cornerRadius: radius).fill(.gray.opacity(opacity)).frame(width: width, height: height))
    }
}

