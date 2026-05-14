//
//  BuildingButtonView.swift
//  Campus App
//
//  Created by LiasPub on 3/7/26.
//

import SwiftUI
import MapKit

struct BuildingButtonView: View {
    @Environment(CampusAppViewModel.self) var manager: CampusAppViewModel
    @State private var waiting: Bool = false
    //Keep widths consistent for BuildingView
    var width: CGFloat
    var body: some View {
        @Bindable var manager = manager
        let height: CGFloat = 50
        let radius: CGFloat = 16
        Button {
            // Want to wait for this to finish so that
            // If there is an alert, we don't close sheet view
            // If there isn't, we close sheet view
            Task {
                waiting = true
                _ = await manager.provideDirections(transportType: manager.directions.transportation.type)
                waiting = false
                if manager.showAlert == false {
                    manager.sheetView.toggle()
                }
            }
        } label:
        {
            // Add ProgressView so that if the function takes awhile, the user still knows it's running...
            if waiting {
                ProgressView()
            } else {
                HStack (alignment: .top) {
                    Image(systemName: "arrowshape.zigzag.right")
                    Text("Get Directions")
                        .bold()
                }
                .alert("Action Not Available", isPresented: $manager.showAlert) {
                    Button("Okay", role: .cancel){
                        manager.showAlert = false
                    }
                } message: {
                    Text("This mode of transportation is not available right now. Please choose a different mode of transportation")
                }
                .foregroundColor(.white)
                .font(.title2)
                .frame(width: width, height: height)
                .background(RoundedRectangle(cornerRadius: radius).fill(Color(.blue)))
            }
        }
    }
}

#Preview {
    BuildingButtonView(width: 360)
        .environment(CampusAppViewModel())
}
