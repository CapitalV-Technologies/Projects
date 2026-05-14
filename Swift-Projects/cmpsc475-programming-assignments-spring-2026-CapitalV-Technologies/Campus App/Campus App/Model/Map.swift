//
//  Map.swift
//  Campus App
//
//  Created by LiasPub on 3/8/26.
//

import Foundation
// Import only to be able to return a specific needed type (MapStyle type)
import _MapKit_SwiftUI
import MapKit

enum MapStyles: String, CaseIterable, Identifiable {
    case standard = "Standard"
    case hybrid = "Hybrid"
    case imagery = "Imagery"
    
    
    var style: MapStyle  {
        switch self {
        case .standard: return .standard
        case .hybrid: return .hybrid
        case .imagery: return .imagery
        }
    }
    
    var id : Self { self }
}

// Create struct for map Info in case we want to add other variables later
struct MapInfo {
    var mapStyle: MapStyles = .standard
}

// Took from AroundTown
struct Downtown {
    // Centered in downtown State College
    //let initialLocation = CLLocation(latitude: 40.794978, longitude: -77.860785)
    static let initialCoordinate = CLLocationCoordinate2D(latitude: 40.794978, longitude: -77.860785)
    
    // define 4 corner points of downtown State College
    static let downtownCoordinates = [(40.791831951313,-77.865203974557),
                               (40.800364570711,-77.853778542571),
                               (40.799476294037,-77.8525124806654),
                               (40.7908968034537,-77.8638607142546)].map {(a,b) in CLLocationCoordinate2D(latitude: a, longitude: b)}
    
    
    static let region = MKCoordinateRegion(center: Downtown.initialCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
}
