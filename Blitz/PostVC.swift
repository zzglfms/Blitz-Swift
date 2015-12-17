//
//  PostVC.swift
//  Blitz
//
//  Created by Tianyang Yu on 10/28/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit
import Foundation

class PostVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var no_image: UIImageView!
    
    // MARK: - Constants
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: - VARIABLES
    var categories = ["Carpool", "FoodDiscover", "House Rental", "Other"]
    var currentViewController: PostSubviewVCInterface!
    var type: String! = "Request"
    var firstPic = true
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView.delegate = self
        
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(375.0, 920.0 + 234)
        
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
        
        // 1
        pageImages = []
        let pageCount = pageImages.count
        
        // 2
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 4
        let pagesScrollViewSize = imageScrollView.frame.size
        imageScrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        // 5
        loadVisiblePages()
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
                scrollView.contentSize = CGSizeMake(375.0, (920.0 + 234))
                let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CarpoolCreatePost")
                newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
                self.currentViewController = newViewController as! PostSubviewVCInterface
                break
            case "FoodDiscover":
                scrollView.contentSize = CGSizeMake(375.0, (770.0 + 234))
                let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FoodDiscoverCreatePost")
                newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
                self.currentViewController = newViewController as! PostSubviewVCInterface
                break
            case "House Rental":
                scrollView.contentSize = CGSizeMake(375.0, (1020.0 + 234))
                let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HouseRentalCreatePost")
                newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
                self.currentViewController = newViewController as! PostSubviewVCInterface
                break
            case "Other":
                scrollView.contentSize = CGSizeMake(375.0, (470.0 + 234))
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
        
        var id_arr_arr: [[String]] = []
        for image in pageImages {
            let imageData = UIImageJPEGRepresentation(image, 0.0)
            let id_array = picture_upload(imageData!)
            id_arr_arr.append(id_array)
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
            "category": categoryTextField.text!,
            "photo": id_arr_arr
        ]
        
        // Add infoFromSubview into postJSONObject
        for (key, value) in infoFromSubview {
            postJSONObject[key] = value
        }

        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): input JSON = %@", postJSONObject)
        
        let result = getResultFromServerAsJSONObject(postJSONObject)
        
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): result = %@", result)
        
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
    
    //Touch The button, change the Image
    @IBAction func changeImageButt(sender: AnyObject) {
        let alert = UIAlertController(title: "Blitz",
            message: "Add a Photo",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default, handler:handle_photo_camera))
        alert.addAction(UIAlertAction(title: "Choose from Library", style: UIAlertActionStyle.Default, handler:handle_photo_library))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handle_photo_camera(alertview: UIAlertAction!){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func handle_photo_library(alterview: UIAlertAction!){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // ImagePicker Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        let imageData = UIImageJPEGRepresentation(image, 0.5)
//        
//        print(imageData?.length)
        
        no_image.hidden = true
        pageImages.append(image)
        
        // 1
        let pageCount = pageImages.count
        
        // 2
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 4
        let pagesScrollViewSize = imageScrollView.frame.size
        imageScrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        // 5
        loadVisiblePages()
        
        
        dismissViewControllerAnimated(true, completion: nil)
//        print("try to save image,  size of pic = ", imageData?.length)
        
        //save image
//        prefs.setObject(imageData, forKey: "avatar")
//        
//        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//        dispatch_async(dispatch_get_global_queue(priority, 0)) {
//            picture_upload(imageData!)
//            dispatch_async(dispatch_get_main_queue()) {
//                NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Upload Done")
//            }
//        }
//        
//        
//        prefs.synchronize()
    }
    
    // MARK: - Scrollview delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    
    // MARK: - Helper Fucntions
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = imageScrollView.frame.size.width
        let page = Int(floor((imageScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Load an individual page, first checking if you've already loaded it
        if let _ = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            var frame = imageScrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            frame = CGRectInset(frame, 10.0, 0.0)
            
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            imageScrollView.addSubview(newPageView)
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
}
