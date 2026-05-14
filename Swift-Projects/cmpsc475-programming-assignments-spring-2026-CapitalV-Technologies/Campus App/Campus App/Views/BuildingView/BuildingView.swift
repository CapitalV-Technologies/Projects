//
//  SwiftUIView.swift
//  Campus App
//
//  Created by LiasPub on 3/7/26.
//

import SwiftUI

struct BuildingView: View {
    @Environment(CampusAppViewModel.self) var manager: CampusAppViewModel
    var building: BuildingEntry
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            ScrollView (.vertical){
            let width: CGFloat = 360
            let height: CGFloat = 210
            let padding: CGFloat = 25
            let radius: CGFloat = 16
                VStack (alignment: .center, spacing: padding){
                    HStack {
                        Text("\(building.name)")
                            .font(.largeTitle)
                            .bold()
                        
                        Spacer()
                        FavoritedView(building: building)
                    }
                    .frame(width: width)
                    .padding(.top, padding)
                    
                    if building.photo != nil {
                        Image(building.photo!)
                            .resizable()
                            .frame(width: width, height: height)
                            .border(.black)
                    } else {
                        NoImageView(width: width, height: height, radius: radius)
                            .frame(width: width, height: height)
                        
                    }
                    VStack {
                        BuildingInfoView(text: "Building Code", image: "building.columns", code: building.opp_bldg_code, width: width)
                            .frame(width: width, height: height / 3)
                        if building.year_constructed != nil {
                            BuildingInfoView(text: "Year Constructed", image: "building.columns", code: Double(building.year_constructed!), width: width)
                                .frame(width: width, height: height / 3)
                        }
                        BuildingInfoView(text: "Coordinates", image: "building.columns", code: building.latitude, longit: building.longitude, width: width)
                            .frame(width: width, height: height / 3)
                    }
                    ChooseTransportationView(width: width)
                    BuildingButtonView(width: width)
                }
                .padding(.horizontal, padding)
            }
        }
    }
    
    // Create an off white background Color
    let backgroundColor: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color(red: 0.95, green: 0.94, blue: 0.88)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
