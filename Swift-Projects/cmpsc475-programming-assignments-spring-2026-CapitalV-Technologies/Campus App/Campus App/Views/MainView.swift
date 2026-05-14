//
//  MainView.swift
//  Campus App
//
//  Created by LiasPub on 3/8/26.
//

import SwiftUI
import MapKit


struct MainView: View {
    @Environment(CampusAppViewModel.self) var manager: CampusAppViewModel
    @State private var path = NavigationPath()
    var body: some View {
        let padding: CGFloat = -50
        let height: CGFloat = 34
        let opacity = 0.5
        @Bindable var manager = manager
        ZStack {
            backgroundColor.ignoresSafeArea()
            NavigationStack (path: $path) {
                VStack {
                    Text("Campus App")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.top, padding)
                    HStack {
                        // Button to center on user's location
                        Button {
                            manager.getCurrentLocation()
                        } label: {
                            Image(systemName: "pointer.arrow")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                        .disabled(manager.disableButton ? true : false)
                        .opacity(manager.disableButton ? opacity : 1.0)
                        .padding(.horizontal)
                        NavigationLink {
                            ListView()
                        } label: {
                            HStack {
                                Text("Buildings")
                                Image(systemName: "arrow.right")
                            }
                            .font(.title3)
                            .foregroundColor(.black)
                        }
                    }
                    ZStack (alignment: .bottom){
                        MapView()
                        if manager.directions.route != nil {
                            DirectionsView()
                        }
                    }
                    FooterView()
                        .frame(height: height)
                }
            }
        }
        .sheet(isPresented: $manager.sheetView) {
            BuildingView(building: manager.selectedBuilding!)
        }
    }
    let backgroundColor: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.black,
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}


#Preview {
    MainView()
        .environment(CampusAppViewModel())
}
