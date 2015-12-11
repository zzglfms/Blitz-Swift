//
//  PostSubviewVCInterface.swift
//  Blitz
//
//  Created by Tianyang Yu on 12/10/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit
import CoreLocation

class OtherCreatePostVC: PostSubviewVCInterface, CLLocationManagerDelegate {
    
    // MARK: - Variables
    var locationManager: CLLocationManager!
    var location: CLLocation!
    var address: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Init LocationManager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        
        if locationManager.respondsToSelector("requestWhenInUseAuthorization") {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CORE LOCATION MANAGER -> GET CURRENT LOCATION OF THE USER
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): %@", error)
        
        // Pop up alert
        let alertController = UIAlertController(title: "Blitz", message: "Failed to Get Your Location", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {}
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        locationManager.stopUpdatingLocation()
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(newLocation, completionHandler: { (placemarks, error) -> Void in
            let placeArray:[CLPlacemark] = placemarks!
            var placemark: CLPlacemark!
            placemark = placeArray[0]
            
            self.location = placemark.location
            
            // Street
            let street = placemark.addressDictionary?["Street"] as? String ?? ""
            // City
            let city = placemark.addressDictionary?["City"] as? String ?? ""
            // Zip code
            let zip = placemark.addressDictionary?["ZIP"] as? String ?? ""
            // State
            let state = placemark.addressDictionary?["State"] as? String ?? ""
            // Country
            let country = placemark.addressDictionary?["Country"] as? String ?? ""
            
            self.address = "\(street), \(zip), \(city), \(state), \(country)"

        })
        
    }
    
    
    
    override func getAllInformation() -> [String: AnyObject] {
        if let _ = location {
            print(location.coordinate.latitude, location.coordinate.longitude)
            return [
                "position": ["address": address, "latidude": location.coordinate.latitude, "longitude": location.coordinate.longitude]
            ]
        }
        else {
            return ["error": "Failed to get your location"]
        }
    }
}