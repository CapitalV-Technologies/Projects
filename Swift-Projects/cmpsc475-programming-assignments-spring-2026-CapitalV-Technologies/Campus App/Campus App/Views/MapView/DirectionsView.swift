//
//  DirectionsView.swift
//  Campus App
//
//  Created by LiasPub on 3/19/26.
//

import SwiftUI
import MapKit

// Pulled most from Around Town app
// Modified to fit my architect
struct DirectionsView: View {
    @Environment(CampusAppViewModel.self) var manager: CampusAppViewModel
    var body : some View {
        @Bindable var manager = manager
        let width: CGFloat = 380
        let height: CGFloat = 230
        let radius: CGFloat = 10
        let opacity = 0.8
        if let route = manager.directions.route {
            VStack {
                HStack {
                    Text("Trip Directions: ")
                    Button("Cancel Trip", role: .destructive) {
                        manager.directions.directions = nil
                        manager.directions.route = nil
                        manager.directions.selectedRoute = nil
                        manager.selectedBuilding = nil
                        manager.directions.currentStep = nil
                    }
                    .bold()
                }
                .font(.title2)
                ScrollView (.horizontal) {
                    HStack {
                        ForEach(route, id:\.self) { r in
                            RouteView(route: r, number: (route.firstIndex(of: r)! + 1))
                        }
                    }
                }
                TabView (selection: $manager.directions.currentStep) {
                    ForEach(manager.directions.directions!, id:\.self) { dir in
                        Text(dir.instructions)
                            .font(.title2)
                            .bold()
                            .tag(dir)
                    }
                }
                .tabViewStyle(.page)
            }
            .frame(width: width, height: height)
            .background(RoundedRectangle(cornerRadius: radius).fill(.gray.opacity(opacity)))
        }
    }
}

#Preview {
    DirectionsView()
        .environment(CampusAppViewModel())
}
