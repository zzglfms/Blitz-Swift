//
//  HouseRentalCreatePostVC.swift
//  Blitz
//
//  Created by Tianyang Yu on 12/9/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit

class HouseRentalCreatePostVC: PostSubviewVCInterface {
    
    // MARK: - Outlets
    @IBOutlet var amenities: [CheckBox]!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!

    // MARK: - Variables
    var datePickerView: UIDatePicker!
    var selectedTextField: UITextField!
    var amenityMap: [String: Bool]! = [:]
    var startDate: NSDate!
    var endDate: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PICKERVIEW DONE BUTTON ACTION
    func donePicker() {
        startDateTextField.resignFirstResponder()
        endDateTextField.resignFirstResponder()
    }
    
    // MARK: - Action Outlets
    @IBAction func textFieldBeginEditing(sender: UITextField) {
        selectedTextField = sender
        
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
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
    
    @IBAction func checkBoxTapped(sender: CheckBox) {
        if sender.isChecked {
            amenityMap[sender.titleLabel!.text!] = false
        }
        else {
            amenityMap[sender.titleLabel!.text!] = true
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    
    // MARK: - Helper func
    func datePickerValueChanged(sender:UIDatePicker) {
        selectedTextField.text = getDateString(sender.date)
        if selectedTextField == startDateTextField {
            startDate = sender.date
        }
        else {
            endDate = sender.date
        }
    }
    
    func getDateString(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        //dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter.stringFromDate(date)
    }
    
    override func getAllInformation() -> [String: AnyObject] {
        var errorMsg: String = ""
        if startDate == nil {
            errorMsg += "Start date is missing\n"
        }
        
        if endDate == nil {
            errorMsg += "End date is missing"
        }
        
        if errorMsg != "" {
            return ["error": errorMsg]
        }
        
        if startDate.compare(endDate) == NSComparisonResult.OrderedDescending
        {
            return ["error": "Start date must be before End date"]
        }
        
        var amenityString = ""
        for (key, boolean) in amenityMap {
            if boolean {
                amenityString += key + ","
            }
        }
        return [
            "startDate": startDateTextField.text!,
            "endDate": endDateTextField.text!,
            "amenity": amenityString
        ]
    }
}
