//
//  Directions.swift
//  Campus App
//
//  Created by LiasPub on 3/7/26.
//

import Foundation
import MapKit

enum Transportation: String, CaseIterable, Identifiable {
    case walking = "Walking"
    case driving = "Driving"
    case cycling = "Cycling"
    case transit = "Transit"
    
    var image: String {
        switch self {
        case .walking: return "figure.walk"
        case .driving: return "car.fill"
        case .cycling: return "bicycle"
        case .transit: return "bus"
        }
    }
    
    // Make type conversion here
    var type: MKDirectionsTransportType {
        switch self {
        case .walking: return .walking
        case .driving: return .automobile
        case .cycling: return .cycling
        case .transit: return .transit
        }
    }
    
    var id : Self { self }
}

struct Directions {
    var transportation: Transportation = .driving
    var route : [MKRoute]?
    var selectedRoute: MKRoute?
    var directions: [MKRoute.Step]?
    var currentStep: MKRoute.Step?
}
