//
//  ChooseTransportationView.swift
//  Campus App
//
//  Created by LiasPub on 3/7/26.
//

import SwiftUI

struct ChooseTransportationView: View {
    @Environment(CampusAppViewModel.self) var manager: CampusAppViewModel
    var width: CGFloat
    var body: some View {
        @Bindable var manager = manager
        let height: CGFloat = 150
        let radius: CGFloat = 16
        let padding: CGFloat = 10
        let shadowRadius: CGFloat = 4
        VStack {
            HStack (alignment: .top) {
                            Image(systemName: "arrowshape.right.circle.fill")
                            Text("Choose Transportation")
                                .bold()
                        }
            .padding(.top, padding)
            .foregroundColor(.black)
            .font(.title2)
            Picker("Directions", selection: $manager.directions.transportation) {
                ForEach(Transportation.allCases) { method in
                    Label(method.rawValue, systemImage: method.image)
                    
                        .tag(method)
                        .foregroundStyle(.white)
                    
                }
            }
            .pickerStyle(.inline)
            .foregroundColor(.white)
            .font(.title)
        }
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: radius).fill(.white).shadow(color: .black, radius: shadowRadius))
        
    }
}

#Preview {
    ChooseTransportationView(width: 360)
        .environment(CampusAppViewModel())
}
