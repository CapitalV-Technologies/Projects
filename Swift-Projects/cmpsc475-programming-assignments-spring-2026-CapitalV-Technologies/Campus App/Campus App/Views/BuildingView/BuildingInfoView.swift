//
//  BuildingInfoView.swift
//  Campus App
//
//  Created by LiasPub on 3/7/26.
//

import SwiftUI

struct BuildingInfoView: View {
    var text: String
    var image: String
    //Building Code or lattitude or year based on parent View input
    //Did it like this to reuse code
    var code: Double
    // If longitude exists, we know lattitude was given
    var longit: Double?
    var width: CGFloat
    var body: some View {
        let size: CGFloat = 30
        let shadowRadius: CGFloat = 4
        let opacity = 0.7
        let radius: CGFloat = 16
        let height: CGFloat = 70
        HStack {
            Image(systemName: image)
                .font(.custom("", size: size))
            VStack (alignment: .leading){
                Text(text)
                    .opacity(opacity)
                if longit == nil {
                    Text("\(Int(code))")
                        .bold()
                        .font(.title2)
                } else {
                    // Should never get 0 here...
                    Text("\(code),\(longit ?? 0)")
                        .bold()
                        .font(.title2)
                }
            }
        }
        .background(RoundedRectangle(cornerRadius: radius).fill(.white).shadow(color: .black, radius: shadowRadius).frame(width: width, height: height))
        
    }
}
