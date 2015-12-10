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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var bountyTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var provideLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    
    // MARK: - Constants
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: - VARIABLES
    var categories = ["Carpool", "FoodDiscover", "House Rental", "Other"]
    var currentViewController: PostSubviewVCInterface!
    var type: String! = "Request"
    
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
        
        provideLabel.hidden = true
        
        self.currentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CarpoolCreatePost") as! PostSubviewVCInterface
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.subView)
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
    
    
    // MARK: - 
    @IBAction func categorySelected(sender: AnyObject) {
        let category = categoryTextField.text!
        
        // Reset type field based on selected category
        if category == "FoodDiscover" || category == "House Rental" {
            provideLabel.hidden = false
            typeSegmentedControl.hidden = true
            type = "Provide"
        }
        else{
            provideLabel.hidden = true
            typeSegmentedControl.hidden = false
            type = typeSegmentedControl.selectedSegmentIndex == 0 ? "Request" : "Provide"
        }
        
        // Load Subview based on selected category
        switch categoryTextField.text! {
            case "Carpool":
                let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CarpoolCreatePost")
                newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
                self.currentViewController = newViewController as! PostSubviewVCInterface
                break
            case "FoodDiscover":
                let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FoodDiscoverCreatePost")
                newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
                self.currentViewController = newViewController as! PostSubviewVCInterface
                break
            case "House Rental":
                let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HouseRentalCreatePost")
                newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
                self.currentViewController = newViewController as! PostSubviewVCInterface
                break
            case "Other":
                let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("OtherCreatePost")
                newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
                self.currentViewController = newViewController as! PostSubviewVCInterface
                break
            default:
                break
        }
        
        
        

    }
    
    
    
    // MARK: - NAVIGATION BAR BACK BUTTON
    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - NAVIGATION BAR DONE BUTTON
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        var inValidMessage: String! = ""
        
        let quantity: Int? = Int(quantityTextField.text!)
        let bounty: Float? = Float(bountyTextField.text!)
        
        // Validation for quantity and bounty
        if let q = quantity {
            if q <= 0 {
                inValidMessage.appendContentsOf("Please enter a postive integer for quantity\n")
            }
        }
        else {
            inValidMessage.appendContentsOf("Please enter a postive integer for quantity\n")
        }
        if let b = bounty {
            if b < 0 {
                inValidMessage.appendContentsOf("Please enter a postive number for bounty\n")
            }
        }
        else {
            inValidMessage.appendContentsOf("Please enter a postive number for bounty\n")
        }
        
        // Validation for title
        if titleTextField.text!.isEmpty {
            inValidMessage.appendContentsOf("Please enter a title for your post\n")
        }
        
        // get information specified to carpool
        let infoFromSubview = currentViewController.getAllInformation()
        
        if let errorString = infoFromSubview["error"] {
            inValidMessage.appendContentsOf(errorString as! String)
        }
        
        // Pop up error message if have invalid field
        if inValidMessage != "" {
            let alertController = UIAlertController(title: "Invalid", message: inValidMessage, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {}
            return
        }
        
        
        // Make a json object for communication with server
        var postJSONObject: [String: AnyObject] = [
            "operation": "CreatePost",
            "username": prefs.stringForKey("USERNAME")!,
            "description": descriptionTextView.text!,
            "quantity": quantity!,
            "title": titleTextField.text!,
            "bounty": bounty!,
            "contact": contactTextField.text!,
            "isRequest": type == "Request",
            "category": categoryTextField.text!
        ]
        
        // Add infoFromSubview into postJSONObject
        for (key, value) in infoFromSubview {
            postJSONObject[key] = value
        }

        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): input JSON = %@", postJSONObject)
        
        let result = getResultFromServerAsJSONObject(postJSONObject)
        
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): %@", result)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Action Outlet
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch typeSegmentedControl.selectedSegmentIndex
        {
        case 0:
            type = "Request"
            break
        case 1:
            type = "Provide"
            break
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Helper function for switching subviews
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.subView!)
        // TODO: Set the starting state of your constraints here
        newViewController.view.layoutIfNeeded()
        
        // TODO: Set the ending state of your constraints here
        
        UIView.animateWithDuration(0.5, animations: {
            // only need to call layoutIfNeeded here
            newViewController.view.layoutIfNeeded()
            },
            completion: { finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMoveToParentViewController(self)
        })
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
}
