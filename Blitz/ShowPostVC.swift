//
//  ShowPostVC.swift
//  Blitz
//
//  Created by ccccccc on 15/11/4.
//  Copyright © 2015年 cs490. All rights reserved.
//

import UIKit
import MapKit

class ShowPostVC: UIViewController,
    UIScrollViewDelegate,
    UITextFieldDelegate,
    MKMapViewDelegate
{
    
    // MARK: - Reference Outlet
    @IBOutlet weak var PostTitleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var BountyLabel: UILabel!
    @IBOutlet weak var QuantityLabel: UILabel!
    @IBOutlet weak var DescrTxt: UITextView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var PostTime: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Variable
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var pointAnnotation:MKPointAnnotation!
    var pinView:MKPinAnnotationView!
    var region: MKCoordinateRegion!
    var coordinates: CLLocationCoordinate2D!
    
    var postdata:JSON = []
    var postID:String = ""
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var username:NSString = ""
    var postOwner: String!
    var amenityMap: [String: Bool] = [:]
    
    
    let amenitiesStrings = ["Kitchen", "Internet", "Wireless Internet", "Air Conditioning", "Heating", "Refriderator", "Washer", "Dryer", "Pets Allowed", "Family/Kid Friendly"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = prefs.stringForKey("USERNAME")!
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        requestData()
        DeleteButton.hidden = true
        
        let post:JSON = postdata["object"]
        setRightButtion(post)
        
        PostTitleLabel.text = post["title"].string!
        
        usernameButton.titleLabel?.text = post["username"].string!
        postOwner = post["username"].string!
        
        // Convert GMT time from server into local time
        let date_iso8601 = NSDate.date(fromString: post["postTime"].string!, format: DateFormat.ISO8601)
        let date_String = date_iso8601?.toString(format: DateFormat.Custom("yyyy-MM-dd HH:mm"))
        //NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): local time = %@", date_String!)
        
        PostTime.text = date_String
        if let description = post["description"].string {
            DescrTxt.text = description
        }
        
        let bounty:String = String(post["bounty"].number!)
        BountyLabel.text = bounty
        QuantityLabel.text = String(post["quantity"].number!)
        
        if(username.isEqualToString(post["username"].string!)){
            DeleteButton.hidden = false
        }
        
        categoryLabel.text = post["category"].string!
        
        if categoryLabel.text == "Carpool" {
            containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width, 890)
            
            // Add from & to pin on mapview
            let fromInfo:JSON = post["from"]
            addPinOnMap(fromInfo["address"].string!, type: "From")
            let toInfo:JSON = post["to"]
            addPinOnMap(toInfo["address"].string!, type: "To")
            
            let effectiveDateLabel = UILabel(frame: CGRectMake(8, 760, 114, 21))
            effectiveDateLabel.textAlignment = NSTextAlignment.Center
            effectiveDateLabel.text = "Effective Time:"
            self.containerScrollView.addSubview(effectiveDateLabel)
            
            let effectiveDateString = UILabel(frame: CGRectMake(130, 760, 212, 21))
            effectiveDateString.textAlignment = NSTextAlignment.Center
            effectiveDateString.text = post["effectiveDate"].string!
            effectiveDateString.textColor = UIColor(red: 251/255.0, green: 110/255.0, blue: 82/255.0, alpha: 1.0)
            self.containerScrollView.addSubview(effectiveDateString)
            
            let repeatLabel = UILabel(frame: CGRectMake(8, 789, 59, 21))
            repeatLabel.textAlignment = NSTextAlignment.Center
            repeatLabel.text = "Repeat:"
            self.containerScrollView.addSubview(repeatLabel)
            
            let repeatString = UILabel(frame: CGRectMake(130, 789, 212, 21))
            repeatString.textAlignment = NSTextAlignment.Center
            repeatString.text = post["repeatString"].string!
            repeatString.textColor = UIColor(red: 251/255.0, green: 110/255.0, blue: 82/255.0, alpha: 1.0)
            self.containerScrollView.addSubview(repeatString)
            
            DeleteButton.frame = CGRectMake(95, 828, 180, 30)
        }
        else {
            containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width, 820)
            let positionInfo:JSON = post["position"]
            addPinOnMap(positionInfo["address"].string!, type: "Position")
            
            if categoryLabel.text == "House Rental" {
                containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width, 1070)
                let startDateLabel = UILabel(frame: CGRectMake(8, 760, 130, 21))
                startDateLabel.textAlignment = NSTextAlignment.Left
                startDateLabel.text = "Start Date:"
                self.containerScrollView.addSubview(startDateLabel)
                
                let effectiveDateString = UILabel(frame: CGRectMake(130, 760, 212, 21))
                effectiveDateString.textAlignment = NSTextAlignment.Center
                effectiveDateString.text = post["startDate"].string!
                effectiveDateString.textColor = UIColor(red: 251/255.0, green: 110/255.0, blue: 82/255.0, alpha: 1.0)
                self.containerScrollView.addSubview(effectiveDateString)
                
                let endDateLabel = UILabel(frame: CGRectMake(8, 789, 130, 21))
                endDateLabel.textAlignment = NSTextAlignment.Left
                endDateLabel.text = "End Date:"
                self.containerScrollView.addSubview(endDateLabel)
                
                let repeatString = UILabel(frame: CGRectMake(130, 789, 212, 21))
                repeatString.textAlignment = NSTextAlignment.Center
                repeatString.text = post["endDate"].string!
                repeatString.textColor = UIColor(red: 251/255.0, green: 110/255.0, blue: 82/255.0, alpha: 1.0)
                self.containerScrollView.addSubview(repeatString)
                
                // amenities Label
                let amenitiesLabel = UILabel(frame: CGRectMake(8, 818, 130, 21))
                amenitiesLabel.textAlignment = NSTextAlignment.Left
                amenitiesLabel.text = "Amenities:"
                self.containerScrollView.addSubview(amenitiesLabel)
                
                // Split amenityString
                let amenityNames = post["amenity"].string!.characters.split{$0 == ","}.map(String.init)
                for name in amenityNames {
                    amenityMap[name] = true
                }
                
                for index in 0...9 {
                    let amenityName = amenitiesStrings[index]
                    
                    let x = CGFloat(25 + (index % 2) * 180)
                    let y = CGFloat(847 + (index / 2) * 29)
                    
                    let amenityLabel = UILabel(frame: CGRectMake(x, y, 212, 21))
                    if let _ = amenityMap[amenityName] {
                        amenityLabel.text = amenityName
                    }
                    else {
                        amenityLabel.textAlignment = NSTextAlignment.Left
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: amenityName)
                        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                        amenityLabel.attributedText = attributeString
                    }
                    self.containerScrollView.addSubview(amenityLabel)
                }
                DeleteButton.frame = CGRectMake(95, 1000, 180, 30)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestData(){
        let input: [String: AnyObject] = [
            "operation": "GetPostDetail",
            "postID": postID
        ]
        
        let result = getResultFromServerAsJSONObject(input)
        
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): result = " + String(result))
        
        postdata = JSON(result)
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject) {
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): result = Delete this post")
        let input: [String: AnyObject] = [
            "operation": "DeletePost",
            "postID": postID
        ]
        let result = getResultFromServerAsJSONObject(input)
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): result = " + String(result))
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func initTableView(){
        let responseTable = self.storyboard?.instantiateViewControllerWithIdentifier("responseTableVC") as! responseTableVC
        responseTable.postID = postID
        let responses:JSON = postdata["object"]["response"]
        responseTable.responses = responses
        self.navigationController?.pushViewController(responseTable, animated: true)
    }
    
    func initResponseView(){
        let responseEditVC = self.storyboard?.instantiateViewControllerWithIdentifier("responseView") as! Blitz.responseEditVC
        responseEditVC.isOwner = false
        responseEditVC.postID = postID
        self.navigationController?.pushViewController(responseEditVC, animated: true)
    }
    
    func clickByOwner(sender:UIButton!)
    {
        let bool = postdata["object"]["TransactionCompleted"].number
        if bool == 0 {
            initTableView()
            
        }
        else {
            let alertController = UIAlertController(title: "Alter!", message:
                "This Transaction has been Completed!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    func clickByViewer(sender:UIButton!)
    {
        let bool = postdata["object"]["TransactionCompleted"].number
        if bool == 0 {
            initResponseView()
        }else{
            let alertController = UIAlertController(title: "Alter!", message:
                "This Transaction has been Completed!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    func setRightButtion(post: JSON){
        let button = UIButton()
        
        if(username.isEqualToString(post["username"].string!)){
            button.setTitle("view replys", forState: .Normal)
            button.addTarget(self, action: "clickByOwner:", forControlEvents: .TouchUpInside)
            button.frame = CGRectMake( -50, -40, 100, 500)
            
        }else{
            button.setTitle("reply", forState: .Normal)
            button.addTarget(self, action: "clickByViewer:", forControlEvents: .TouchUpInside)
            button.frame = CGRectMake( -50, -40, 60, 500)
        }
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
    }
    
    @IBAction func usernameTapped(sender: UIButton) {
        usernameButton.titleLabel!.text = postOwner
    }
    
    
    // MARK: - ADD A PIN ON THE MAP
    func addPinOnMap(address: String, type: String) {
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
                self.mapView.centerCoordinate = self.pointAnnotation.coordinate
                self.mapView.addAnnotation(self.pinView.annotation!)
                
                // Zoom the Map to the location
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            }
            
        }
    }
    
    
}
