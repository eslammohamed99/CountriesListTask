//
//  LocationManager.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 26/03/2025.
//

import CoreLocation
import SwiftUI
import Combine

public protocol LocationManagerCallBackDelegate {
    var userLocation: CurrentValueSubject<CLLocationCoordinate2D?, Never> { get set }
    var getAccess: CurrentValueSubject<Bool?, Never> { get set }
    
    func startUpdatingLocation()
}

public final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, LocationManagerCallBackDelegate {
    public var userLocation: CurrentValueSubject<CLLocationCoordinate2D?, Never> = .init(nil)
    
    public var getAccess: CurrentValueSubject<Bool?, Never> = .init(nil)
    
    private var locationManager = CLLocationManager()
    

    public override init() {
        super.init()
        
    }
    
    public func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                getAccess.send(nil)
            case .authorizedWhenInUse, .authorizedAlways:
                getAccess.send(true)
                locationManager.startUpdatingLocation()
            case .denied, .restricted:
                getAccess.send(false)
            @unknown default:
                break
            }
        }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation.send(location.coordinate)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
    }
}
