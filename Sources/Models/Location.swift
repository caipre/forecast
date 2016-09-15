//
// Forecast
//
//

import Foundation
import CoreLocation

import Publinks
import SwiftyTimer

class Location {
    
    let publink = Publink<Location>()
    
    let geocoder: CLGeocoder
    let locationmanager: CLLocationManager
    let delegate = LocationManagerDelegate()
    
    var placemark: CLPlacemark? {
        didSet {
            publink.publish(self)
        }
    }
    
    init() {
        geocoder = CLGeocoder()
        locationmanager = CLLocationManager()
        locationmanager.delegate = delegate
        locationmanager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        if let last = locationmanager.location {
            lookup(last)
        }
    }
    
    var canDetectLocation: Bool {
        get {
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied:
                return false
            default:
                return CLLocationManager.locationServicesEnabled()
            }
        }
    }
    
    var coordinates: (Double, Double)? {
        get {
            guard placemark?.location?.coordinate != nil else { return nil }
            let coord = placemark!.location!.coordinate
            return (coord.latitude, coord.longitude)
        }
    }
    
    var description: String? {
        get {
            guard placemark?.locality != nil else { return nil }
            guard placemark?.administrativeArea != nil else { return nil }
            return "\(placemark!.locality!), \(placemark!.administrativeArea!)"
        }
    }
    
    func startUpdating() {
        guard canDetectLocation else { return }
        locationmanager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        locationmanager.stopUpdatingLocation()
    }

    
    func lookup(_ address: String) {
        geocoder.geocodeAddressString(address, completionHandler: geocoderCallback)
    }
    
    func lookup(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location, completionHandler: geocoderCallback)
    }
    
    func geocoderCallback(placemarks: [CLPlacemark]?, error: Error?) {
        // todo: cache lookups
        guard error == nil else { return }
        guard let result = placemarks?.first else { return }
        placemark = result
    }
    
}

class LocationManagerDelegate : NSObject, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            location.stopUpdating()
        } else if status == .authorized {
            location.startUpdating()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateTo newLocation: CLLocation, from oldLocation: CLLocation) {
        location.lookup(newLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        assert(locations.last != nil)
        location.lookup(locations.last!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else { return }
        if error.code == .denied {
            location.stopUpdating()
        }
    }
    
}
