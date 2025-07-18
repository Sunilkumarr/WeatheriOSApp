//
//  LocationManager.swift
//  WeatheriOSApp
//
//  Created by Sunil kumar on 17/07/25.
//

import Foundation
import CoreLocation
import SwiftUI

struct EquatableLocation: Equatable {
    let lat: Double
    let lon: Double
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    var manager = CLLocationManager()
    @Published var errorString: String?
    @Published var equatableLocation: EquatableLocation?
    @Published var cityName: String?
    
    override init() {
        super.init()
    }
    
    func startUpdatingLocation() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        DispatchQueue.global(qos: .userInitiated).async {
            if CLLocationManager.locationServicesEnabled() {
                self.manager.requestLocation()
            } else {
                print("Location services are not enabled.")
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            if let coordinate = locations.last?.coordinate {
                self.equatableLocation = EquatableLocation(lat: coordinate.latitude, lon: coordinate.longitude)
                self.fetchCityName(from: coordinate)
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        DispatchQueue.main.async {
            self.errorString = error.localizedDescription
        }
    }
    
    private func fetchCityName(from coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? placemark.subAdministrativeArea ?? placemark.administrativeArea ?? placemark.country
                DispatchQueue.main.async {
                    self.cityName = city
                }
            } else {
                DispatchQueue.main.async {
                    self.cityName = nil
                }
            }
        }
    }
}
