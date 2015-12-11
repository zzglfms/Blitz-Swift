//
//  MapVC.swift
//  Blitz
//
//  Created by Tianyang Yu on 10/31/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
    
    // MARK: - Outlets
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Variables
    var titleString: String!
    var locationManager: CLLocationManager!
    
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinView:MKPinAnnotationView!
    var region: MKCoordinateRegion!
    var coordinates: CLLocationCoordinate2D!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.addressTextField.delegate = self
        self.addressTitle.text = titleString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            // Show address on addressTxt
            self.addressTextField.text = "\(street), \(zip), \(city), \(state), \(country)"
            // Add a Pin to the Map
            if self.addressTextField!.text! != "" {
                self.addPinOnMap(self.addressTextField.text!)
            }
        })
        
    }
    
    
    // MARK: - ADD A PIN ON THE MAP
    func addPinOnMap(address: String) {
        if mapView.annotations.count != 0 {
            annotation = mapView.annotations[0]
            mapView.removeAnnotation(annotation)
        }
        
        // Make a search on the Map
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = address
        localSearch = MKLocalSearch(request: localSearchRequest)
        
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            // Place not found or GPS not available
            if localSearchResponse == nil  {
                // Pop up alert
                let alertController = UIAlertController(title: "Blitz", message: "Place not found, or GPS not available", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true) {}
            } else {
                // Add PointAnnonation text and a Pin to the Map
                self.pointAnnotation = MKPointAnnotation()
                self.pointAnnotation.title = "From"
                self.pointAnnotation.subtitle = self.addressTextField.text
                self.pointAnnotation.coordinate = CLLocationCoordinate2D( latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:localSearchResponse!.boundingRegion.center.longitude)
                
                // Store coordinates (to use later while posting the Ad)
                self.coordinates = self.pointAnnotation.coordinate
                
                self.pinView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                self.mapView.centerCoordinate = self.pointAnnotation.coordinate
                self.mapView.addAnnotation(self.pinView.annotation!)
                
                // Zoom the Map to the location
                self.region = MKCoordinateRegionMakeWithDistance(self.pointAnnotation.coordinate, 1000, 1000);
                self.mapView.setRegion(self.region, animated: true)
                self.mapView.regionThatFits(self.region)
                self.mapView.reloadInputViews()
            }
            
        }
    }
    
    
    // MARK: - UITextField Delegate
    func textFieldDidEndEditing(textField: UITextField) {
        // Get address for the Map
        if textField == addressTextField {
            if addressTextField.text != "" {
                addPinOnMap(addressTextField.text!)
            }
        }
    }
    
    // MARK: - Action Outlet
    @IBAction func currentLocationButtonTapped(sender: UIButton) {
        // Init LocationManager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        
        if locationManager.respondsToSelector("requestWhenInUseAuthorization") {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Helper Function
    func getLocationCoordinate() -> (address: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, success: Bool) {
        if mapView.annotations.count != 0 {
            return (addressTextField.text!, mapView.annotations[0].coordinate.latitude, mapView.annotations[0].coordinate.longitude, true)
        }
        
        return ("Error" ,0, 0, false)
    }
    
}
