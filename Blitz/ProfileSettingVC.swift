//
//  ProfileSettingVC.swift
//  Blitz
//
//  Created by ccccccc on 15/10/28.
//  Copyright © 2015年 cs490. All rights reserved.
//

import Foundation
import UIKit


class ProfileSettingVC: UIViewController,
    UITextFieldDelegate,
    UIAlertViewDelegate,
    UINavigationControllerDelegate,
UIImagePickerControllerDelegate {
    
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var avatarimage: UIImageView!
    @IBOutlet weak var webSiteTextField: UITextField!
    @IBOutlet weak var useremailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    
    
    var APP_NAME = "Blitz"
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        localStroageRead()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Touch The button, change the Image
    @IBAction func changeImageButt(sender: AnyObject) {
        let alert = UIAlertController(title: APP_NAME,
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
        let imageData = UIImageJPEGRepresentation(image, 100)
        avatarimage.image = UIImage.init(data: imageData!)
        dismissViewControllerAnimated(true, completion: nil)
        print("try to save image")
        
        //save image
        prefs.setObject(imageData, forKey: "avatar")
        prefs.synchronize()
    }
    
    func localStroageRead(){
        //local data read
        if let username = prefs.stringForKey("USERNAME"){
            usernameLabel.text = username
        }
        
        if let email = prefs.stringForKey("EMAIL"){
            useremailLabel.text = email
        }
        
        if let imageData = prefs.objectForKey("avatar")as? NSData{
            let image = UIImage.init(data: imageData)
            avatarimage.image = image
        }
        
        if let fullname = prefs.stringForKey("FULLNAME"){
            fullNameTextField.text = fullname
        }
        
        if let phone = prefs.stringForKey("PHONE"){
            phoneTextField.text = phone
        }
        
        if let website = prefs.stringForKey("WEBSITE"){
            webSiteTextField.text = website
        }
    }
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        let fullname:NSString = fullNameTextField.text!
        let phone:NSString = phoneTextField.text!
        let website:NSString = webSiteTextField.text!
        
        
        if (fullname.isEqualToString("") || phone.isEqualToString("") || website.isEqualToString("http://")){
            print("no action")
        }
        else{
            localStorageWrite()
        }
    }

    func localStorageWrite(){
        let fullname:NSString = fullNameTextField.text!
        let phone:NSString = phoneTextField.text!
        let website:NSString = webSiteTextField.text!
        
        print("fullname = " + fullNameTextField.text!)
        prefs.setObject(fullname, forKey: "FULLNAME")
        print("phone = " + phoneTextField.text!)
        prefs.setObject(phone, forKey: "PHONE")
        print("website = " + webSiteTextField.text!)
        prefs.setObject(website, forKey: "WEBSITE")

    }
    
    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func testGetProfile(sender: UIButton) {
        var pwTextField: UITextField?
        var pwcTextField: UITextField?
        
        let alert = UIAlertController(title: APP_NAME,
            message: "Change Your Password",
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            pwTextField = textField
            pwTextField!.placeholder = "Password"
            pwTextField!.secureTextEntry = true
        }
        alert.addTextFieldWithConfigurationHandler { (textField) in
            pwcTextField = textField
            pwcTextField!.placeholder = "Password Confirmation"
            pwcTextField!.secureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            let pw:NSString = pwTextField!.text!
            let pwc:NSString = pwcTextField!.text!
            if(pw.isEqualToString(pwc as String)){
                if(pw.length < 6){
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    let alert_ok = UIAlertController(title: "Length of Password is at least 6!",
                        message: "Try again!",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    alert_ok.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:nil))
                    self.presentViewController(alert_ok, animated: true, completion: nil)
                }
                else{
                    //print((pw as String) + "\n" + (pwc as String))
                    let username = self.prefs.stringForKey("USERNAME")
                    let subjson1 = ["username": username!]
                    let subjson2 = ["password": (pw as String)]
                    let jsonObject:[String: AnyObject] = [
                        "operation": "ModifyProfile",
                        "username": username!,
                        "changes": [ subjson1,
                            subjson2
                        ]
                    ]
                    let valid = NSJSONSerialization.isValidJSONObject(jsonObject) // true
                    if valid {
                        let result = request(jsonObject)
                        let result_JSON = JSON(result)
                        print(result_JSON)
                    }
                }
                
            }else{
                alert.dismissViewControllerAnimated(true, completion: nil)
                let alert_ok = UIAlertController(title: "Passwords doesn't Match",
                    message: "Try again!",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert_ok.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:nil))
                self.presentViewController(alert_ok, animated: true, completion: nil)
            }
        }
        alert.addAction(OKAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    
}
