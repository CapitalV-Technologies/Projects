//
//  LocoTasksViewModel.swift
//  LocoTasks
//
//  Created by LiasPub on 4/12/26.
//

import Foundation
import CoreLocation
import _MapKit_SwiftUI

@Observable
class LocoTasksViewModel: NSObject, CLLocationManagerDelegate {
    
    var mapInfo = MapInfo()
    var cllocationManager : CLLocationManager = CLLocationManager()
    var cameraPosition : MapCameraPosition
    
    
    override init() {
        cameraPosition = .userLocation(fallback: .automatic)
        super.init()
        cllocationManager.delegate = self
    }
    
    func getCurrentLocation() {
            self.cameraPosition = .userLocation(fallback: .automatic)
        }
    
    func getLat() -> Double {
        let lat = Double(cllocationManager.location?.coordinate.latitude ?? 0)
        return lat
    }
    
    func getLong() -> Double {
        let long = Double(cllocationManager.location?.coordinate.longitude ?? 0)
        return long
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
}
