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
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
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
        if let imageData = prefs.objectForKey("avatar")as? NSData{
            let image = UIImage.init(data: imageData)
            avatarimage.image = image
        }
    }
    
    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
