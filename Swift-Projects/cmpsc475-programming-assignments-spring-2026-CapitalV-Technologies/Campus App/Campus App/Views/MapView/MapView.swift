//
//  MapView.swift
//  Campus App
//
//  Created by LiasPub on 3/8/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(CampusAppViewModel.self) var manager: CampusAppViewModel
    var body: some View {
        @Bindable var manager = manager
        let opacity = 0.5
        let lineWidth: CGFloat = 5
        Map(position: $manager.cameraPosition) {
            UserAnnotation()
            ForEach(manager.selectedBuildings) { building in
                Annotation("",coordinate: CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)) {
                    AnnotationView(building: building)
                        .environment(manager)
                }
            }
            // check if directions were asked for and plot polylines
            if let route = manager.directions.route {
                ForEach(route, id: \.self) { r in
                    MapPolyline(r.polyline)
                        .stroke(.blue.opacity(r == manager.directions.selectedRoute ? 1.0 : opacity), lineWidth: lineWidth)
                }
                if let step = manager.directions.currentStep {
                    MapPolyline(step.polyline)
                        .stroke(.yellow, lineWidth: lineWidth)
                }
            }
                                
        }
        .mapStyle(manager.mapInfo.mapStyle.style)
        // Watch for map movement
        // If true, enable user button again
        .onChange(of: manager.cameraPosition) { old, new in
            // Make sure user changes camera position, not the button
            if new.positionedByUser {
                manager.disableButton = false
            }
        }
    }
}

#Preview {
    MapView()
        .environment(CampusAppViewModel())
}
