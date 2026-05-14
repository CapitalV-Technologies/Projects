//
//  Map.swift
//  LocoTasks
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
