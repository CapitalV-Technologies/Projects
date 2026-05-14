//
//  RouteView.swift
//  Campus App
//
//  Created by LiasPub on 3/19/26.
//

import SwiftUI
import MapKit

struct RouteView: View {
    @Environment(CampusAppViewModel.self) var manager: CampusAppViewModel
    var route: MKRoute
    var number: Int
    var body: some View {
        // We know this returns total seconds
        let travelTime = route.expectedTravelTime
        let width: CGFloat = 170
        let height: CGFloat = 60
        let radius: CGFloat = 10
        let shadowRadius: CGFloat = 5
        Button {
            manager.directions.selectedRoute = route
            manager.directions.directions = route.steps
            manager.directions.currentStep = nil
        } label: {
            HStack {
                Text("\(number)")
                    .font(.title)
                    .foregroundColor(route == manager.directions.selectedRoute ? .yellow : .blue)
                VStack {
                    Text(manager.calculateTime(seconds: travelTime))
                    Text(manager.calculateETA(seconds: travelTime))
                }
            }
            .frame(width: width, height: height)
            .background(RoundedRectangle(cornerRadius: radius).fill(.white).shadow(color: .black, radius: shadowRadius))
        }
    }
}
