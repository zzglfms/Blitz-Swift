//
//  PostVC.swift
//  Blitz
//
//  Created by Tianyang Yu on 10/28/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit

class PostVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: - OUTLETS
    @IBOutlet var categoryPicker: UIPickerView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!

    // MARK: - VARIABLES
    var categories = ["Carpool", "Food Discoer", "Tutor", "House Rental", "Need A Ride"]
    var carpoolPostVC: CarpoolPostVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(375.0, 920.0)
        
        // Do any additional setup after loading the view.
        categoryTextField.text = categories[0]
        categoryPicker.showsSelectionIndicator = true
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
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

        categoryTextField.inputView = categoryPicker
        categoryTextField.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - PICKERVIEW DELEGATES
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return categories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        categoryTextField.text = categories[row]
    }
    
    
    // MARK: - PICKERVIEW DONE BUTTON ACTION
    func donePicker() {
        categoryTextField.resignFirstResponder()
    }
    
    
    // MARK: - NAVIGATION BAR BACK BUTTON
    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        //let controller = storyboard!.instantiateViewControllerWithIdentifier("CarpoolSubview") as! CarpoolPostVC
        NSLog("Here")
        let info = carpoolPostVC.getAllInformation()
        NSLog("From"+info.from)
    }
    

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "carpoolPost"
        {
            carpoolPostVC = segue.destinationViewController as! CarpoolPostVC
        }
    }
}
