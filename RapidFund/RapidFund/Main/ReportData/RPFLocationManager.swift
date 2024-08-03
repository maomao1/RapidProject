////
////  RPFLocationManager.swift
////  RapidFund
////
////  Created by 毛亚恒 on 2024/7/21.
////
//
import CoreLocation
import MBProgressHUD
import SystemConfiguration.CaptiveNetwork
class RPFLocationManager: NSObject {
    static let manager = RPFLocationManager()
    typealias LocationInfoCall = (String,String,String,String,String,String,String,[NetworkInfo]?) -> ()
    typealias AnalysisInfoCall = (String,String) -> ()
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var locationInfoHandle: LocationInfoCall?
    var analysisHandle: AnalysisInfoCall?
    var status: CLAuthorizationStatus?
    
     override init() {
         super.init()
    }
    
    
    func requestLocationAuthorizationStatus()  {
        self.locationManager.delegate = self
        if #available(iOS 14.0, *) {
            status = self.locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        switch status {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("")
            if let handle = self.locationInfoHandle {
                handle("","","","","","\(0)","\(0)",RPFDeviceManager.getWiFiName())
            }
            if let handle = self.analysisHandle {
                handle("\(0)","\(0)")
            }
        case .none:
            self.startGettingLocation()
        case .some(.authorizedAlways):
            self.startGettingLocation()
        case .some(.authorizedWhenInUse):
            self.startGettingLocation()
        @unknown default:
            fatalError("Unknown locationManager authorization status.")
        }
       
    }
    
    func startGettingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func stopGettingLocation() {
        self.locationManager.stopUpdatingLocation()
    }

}
//
extension RPFLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
        if let location = locations.first {
            geocoder.reverseGeocodeLocation(location) {[weak self] (placemarks, error) in
                guard let `self` = self else { return }
                if let placemark = placemarks?.first {
                    let country = placemark.country ?? "Unknown"
                    let countryCode = placemark.isoCountryCode ?? "Unknown"
                    let administrativeArea = placemark.administrativeArea ?? "Unknown"
                    let locality = placemark.locality ?? "Unknown"
                    let thoroughfare = placemark.thoroughfare ?? "Unknown"
                    let latitude = location.coordinate.latitude
                    let longitude = location.coordinate.longitude
                    if let handle = self.locationInfoHandle {
                        handle(country,countryCode,administrativeArea,locality,thoroughfare,"\(longitude)","\(latitude)",RPFDeviceManager.getWiFiName())
                    }
                    if let handle = self.analysisHandle {
                        handle("\(longitude)","\(latitude)")
                    }
                    self.stopGettingLocation()
                    
                }
            }
        }
    }
        
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
        if let handle = self.locationInfoHandle {
            handle("","","","","","\(0)","\(0)",RPFDeviceManager.getWiFiName())
        }
        if let handle = self.analysisHandle {
            handle("\(0)","\(0)")
        }
    }
}



struct NetworkInfo {
    var interface: String
    var success: Bool = false
    var ssid: String?
    var bssid: String?
}
