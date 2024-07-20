//
//  RPFLocationManager.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/21.
//

import CoreLocation
import MBProgressHUD
class RPFLocationManager: NSObject {
//    static let manager = RPFLocationManager()
    typealias LocationInfoCall = (String,String,String,String,String,String,String) -> ()
    var manager = CLLocationManager()
    var geocoder = CLGeocoder()
    var locationInfoHandle: LocationInfoCall?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
//        startGettingLocation()
    }
    
    func startGettingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopGettingLocation() {
        manager.stopUpdatingLocation()
    }
}

extension RPFLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
        if let location = locations.first {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemark = placemarks?.first {
                    let country = placemark.country ?? "Unknown"
                    let countryCode = placemark.isoCountryCode ?? "Unknown"
                    let administrativeArea = placemark.administrativeArea ?? "Unknown"
                    let locality = placemark.locality ?? "Unknown"
                    let thoroughfare = placemark.thoroughfare ?? "Unknown"
                    let latitude = location.coordinate.latitude
                    let longitude = location.coordinate.longitude
                    if let handle = self.locationInfoHandle {
                        handle(country,countryCode,administrativeArea,locality,thoroughfare,"\(longitude)","\(latitude)")
                    }
                    self.stopGettingLocation()
                }
            }
        }
    }
        
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
    }
}
