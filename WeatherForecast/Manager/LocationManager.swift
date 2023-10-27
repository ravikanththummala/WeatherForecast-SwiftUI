//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Ravikanth Thummala on 10/27/23.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
    var location: CLLocationCoordinate2D? { get }
    var locationError: LocationError? { get }
    func requestLocation()
}

class LocationManager: NSObject, ObservableObject, LocationManagerProtocol {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var locationError: LocationError?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = .notAvailable
    }
}

enum LocationError: Error {
    case notAvailable
    case unknown
}

extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "Location not available"
        case .unknown:
            return "unknown error"
        }
    }
}
