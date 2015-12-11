//
//  CarpoolPostVC.swift
//  Blitz
//
//  Created by Tianyang Yu on 10/31/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CarpoolPostVC: PostSubviewVCInterface {

    // MARK: - Outlets
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var repeatTextField: UILabel!
    
    // MARK: - Variables
    var mapVC: FromToMapVC!
    var datePickerView:UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.repeatTextField.text = "None"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "carpoolMapView"
        {
            mapVC = segue.destinationViewController as! FromToMapVC
        }
        else if segue.identifier == "carpoolRepeatView"
        {
            let navController = segue.destinationViewController as! UINavigationController
            let repeatVC = navController.viewControllers[0] as! RepeatTableVC
            repeatVC.carpoolController = self
            repeatVC.passingMessage = self.repeatTextField.text
        }
    }
    
    // MARK: - PICKERVIEW DONE BUTTON ACTION
    func donePicker() {
        dateTextField.resignFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func textFieldEditing(sender: UITextField) {
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime

        // Set up toolBar of the picker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true

        sender.inputView = datePickerView
        sender.inputAccessoryView = toolBar
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func textFieldEndEditing(sender: UITextField) {
        sender.text = getDateString(datePickerView.date)
    }
    
    
    // MARK: - Helper func
    func datePickerValueChanged(sender:UIDatePicker) {
        dateTextField.text = getDateString(sender.date)
    }
    
    func getDateString(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter.stringFromDate(date)
    }
    
    override func getAllInformation() -> [String: AnyObject]{
        let fromInfo = mapVC.getLocationCoordinate("From")
        let toInfo = mapVC.getLocationCoordinate("To")
        
        if fromInfo.success && toInfo.success {
            return [
                "position": ["address": fromInfo.address, "latitude": fromInfo.latitude, "longitude": fromInfo.longitude],
                "from": ["address": fromInfo.address, "latitude": fromInfo.latitude, "longitude": fromInfo.longitude],
                "to": ["address": toInfo.address, "latitude": toInfo.latitude, "longitude": toInfo.longitude],
                "effectiveDate": dateTextField.text!,
                "repeatString": repeatTextField.text!
            ]
        }
        else {
            var errorString: String = ""
            if !fromInfo.success {
                errorString += "'From' location is missing\n"
            }
            if !toInfo.success {
                errorString += "'To‘ Location is missing\n"
            }
            return ["error": errorString]
        }
    }

}
