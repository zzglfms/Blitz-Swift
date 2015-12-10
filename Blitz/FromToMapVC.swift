//
//  FromToMapVC.swift
//  Blitz
//
//  Created by Tianyang Yu on 10/31/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FromToMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
    
    // MARK: - Outlets
    @IBOutlet weak var fromAddressTextField: UITextField!
    @IBOutlet weak var toAddressTextField: UITextField!
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
    
    var tappedButton: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.fromAddressTextField.delegate = self
        self.toAddressTextField.delegate = self
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
            
            if self.tappedButton! == "from" {
                // Show address on addressTxt
                self.fromAddressTextField.text = "\(street), \(zip), \(city), \(state), \(country)"
                // Add a Pin to the Map
                if self.fromAddressTextField!.text! != "" {
                    self.addPinOnMap(self.fromAddressTextField.text!, type: "From")
                }
            }
            else if self.tappedButton! == "to" {
                // Show address on addressTxt
                self.toAddressTextField.text = "\(street), \(zip), \(city), \(state), \(country)"
                // Add a Pin to the Map
                if self.toAddressTextField!.text! != "" {
                    self.addPinOnMap(self.toAddressTextField.text!, type: "To")
                }
            }
            else {
                NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): tappedButton has invalid value = %@", self.tappedButton)
            }
        })
        
    }
    
    
    // MARK: - ADD A PIN ON THE MAP
    func addPinOnMap(address: String, type: String) {
        if mapView.annotations.count != 0 {
            for annotation in mapView.annotations {
                if annotation.title!! == type{
                    mapView.removeAnnotation(annotation)
                }
            }
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
                self.pointAnnotation.title = type
                self.pointAnnotation.subtitle = address
                self.pointAnnotation.coordinate = CLLocationCoordinate2D( latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:localSearchResponse!.boundingRegion.center.longitude)
                
                // Store coordinates (to use later while posting the Ad)
                self.coordinates = self.pointAnnotation.coordinate
                
                self.pinView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                self.pinView.pinTintColor = UIColor.blueColor()
                //self.mapView.centerCoordinate = self.pointAnnotation.coordinate
                self.mapView.addAnnotation(self.pinView.annotation!)
                
                // Zoom the Map to the location
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                if self.mapView.annotations.count >= 2 {
                    let source = MKMapItem( placemark: MKPlacemark(
                        coordinate: self.mapView.annotations[0].coordinate,
                        addressDictionary: nil))
                    let destination = MKMapItem(placemark: MKPlacemark(
                        coordinate: self.mapView.annotations[1].coordinate,
                        addressDictionary: nil))
                    
                    let directionsRequest = MKDirectionsRequest()
                    directionsRequest.source = source
                    directionsRequest.destination = destination
                    
                    let directions = MKDirections(request: directionsRequest)
                    
                    directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
                        print("Error: " + String(error))
                        print("Distance: "+String(response!.routes.first?.distance))
                    }
                }
            }
            
        }
    }
    
    
    // MARK: - UITextField Delegate
    func textFieldDidEndEditing(textField: UITextField) {
        // Get address for the Map
        if textField == fromAddressTextField {
            if fromAddressTextField.text != "" {
                addPinOnMap(fromAddressTextField.text!, type: "From")
            }
        }
        else if textField == toAddressTextField {
            if toAddressTextField.text != "" {
                addPinOnMap(toAddressTextField.text!, type: "To")
            }
        }
    }
    
    // MARK: - Action Outlet
    @IBAction func fromCurrentLocationButtonTapped(sender: UIButton) {
        // Set 'tappedButton' to 'from', used to let loctionManager didUpdateLocation know which textfield to be filled
        tappedButton = "from"
        
        // Init LocationManager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        
        if locationManager.respondsToSelector("requestWhenInUseAuthorization") {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func toCurrentLocationButtonTapped(sender: UIButton) {
        // Set 'tappedButton' to 'to', used to let loctionManager didUpdateLocation know which textfield to be filled
        tappedButton = "to"
        
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
    func getLocationCoordinate(type: String) -> (latitude: CLLocationDegrees, longitude: CLLocationDegrees, success: Bool) {
        if mapView.annotations.count != 0 {
            for annotation in mapView.annotations {
                if annotation.title!! == type{
                    return (annotation.coordinate.latitude, annotation.coordinate.longitude, true)
                }
            }
        }
        
        return (0, 0, false)
    }
    
}
