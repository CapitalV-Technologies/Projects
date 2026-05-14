//
//  CampusAppViewModel.swift
//  Campus App
//
//  Created by LiasPub on 3/7/26.
//

import Foundation
import _MapKit_SwiftUI

@Observable
class CampusAppViewModel: NSObject, CLLocationManagerDelegate {
    
    var directions: Directions = Directions()
    var mapInfo: MapInfo = MapInfo()
    
    var buildings: BuildingList = BuildingList()
    var buildingList: Lists = .all
    var selectedBuilding: BuildingEntry?
    var cllocationManager : CLLocationManager = CLLocationManager()
    var sheetView: Bool = false
    
    var cameraPosition : MapCameraPosition = .region(Downtown.region)
    var disableButton: Bool = false
    var showAlert: Bool = false
    
    override init() {
        super.init()
        cllocationManager.delegate = self
        
    }

    // Computed Property
    var favoritedBuildings: [BuildingEntry] {
        var list: [BuildingEntry] = []
        for item in buildings.buildingLists {
            if item.isFavorited == true {
                list.append(item)
            }
        }
        return list
    }
    
    // Computed Property
    var selectedBuildings: [BuildingEntry] {
        var list: [BuildingEntry] = []
        for item in buildings.buildingLists {
            if item.isSelected == true {
                list.append(item)
            }
        }
        return list
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .notDetermined:
                cllocationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                cllocationManager.startUpdatingLocation()
            default:
                cllocationManager.stopUpdatingLocation()
            }
        }
    
    func getCurrentLocation() {
        self.cameraPosition = .userLocation(fallback: .automatic)
        self.disableButton = true
    }

    func provideDirections(transportType : MKDirectionsTransportType) async {
        
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(location: CLLocation(latitude: selectedBuilding!.latitude, longitude: selectedBuilding!.longitude), address: nil)
        request.transportType = transportType
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        do {
            let response = try await directions.calculate()
            let r = response.routes
            self.directions.route = r
            self.directions.selectedRoute = r.first
            self.directions.directions = r.first?.steps
            return
        }
        catch {
            print(error.localizedDescription);
            self.showAlert = true;
            return
        }
    }
    
    func calculateTime(seconds: Double) -> String {
        var total_minutes = Int(seconds) / 60
        if  total_minutes > 60 {
            let total_hours = total_minutes / 60
            total_minutes = total_minutes % 60
            return "\(total_hours) hours and \(total_minutes) mins"
        }
        return "\(total_minutes) mins"
    }
    
    func calculateETA(seconds: Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let timeString = dateFormatter.string(from: ( Date() + seconds))
        return timeString
    }
}
