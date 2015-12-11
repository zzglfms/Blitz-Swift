//
//  responseEditVC.swift
//  Blitz
//
//  Created by ccccccc on 15/11/26.
//  Copyright © 2015年 cs490. All rights reserved.
//

import UIKit

class responseEditVC: UIViewController {
    
    //references
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var responseTextField: UITextView!
    @IBOutlet weak var bounty: UITextField!
    @IBOutlet weak var userButton: UIButton!
    
    //variables
    var isOwner = true;
    var postID:String = ""
    var username = ""
    var price: Double = 0
    var comment = ""
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(response)
        if isOwner { //
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Select", style: .Plain, target: self,
                action: "OwnerSelection:")
            responseTextField.editable = false
            bounty.enabled = false
            responseTextField.text = comment
            bounty.text = String(price)
            //Button
            userButton.setTitle(username, forState: UIControlState.Normal)
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Done", style: .Plain, target: self,
                action: "PostResponse:")
            userButton.setTitle(prefs.stringForKey("USERNAME")! , forState: UIControlState.Normal)
            userButton.enabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - NAVIGATION BAR BACK BUTTON
    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - POST THE RESPONSE
    @IBAction func PostResponse(sender: UIBarButtonItem){
        let username = prefs.stringForKey("USERNAME")!
        let comment: NSString = responseTextField.text
        let offeredBounty = Int(bounty.text!)
        var invalidMessage = ""
        
        // Validation for bounty
        if let q = offeredBounty {
            if q <= 0 {
                invalidMessage.appendContentsOf("Please enter a postive integer for bounty")
            }
        }
        else {
            invalidMessage.appendContentsOf("Please enter a postive integer for bounty")
        }
        
        if invalidMessage != "" {
            let alertController = UIAlertController(title: "Invalid", message: invalidMessage, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {}
            return
        }
        
        let jsonObject: [String: AnyObject] = [
            "operation":"OfferPrice",
            "postID":postID,
            "username":username,
            "comment":comment,
            "offeredPrice":offeredBounty!
        ]
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): result = " + String(jsonObject))
        getResultFromServerAsJSONObject(jsonObject)
        self.navigationController?.popViewControllerAnimated(true)
        
        let msg = String(username + " Reply Your Post")
        sendNotification(username, msg: msg)
    }
    
    //MARK: - OWNER SELECT THIS RESPONSE
    @IBAction func OwnerSelection(sender: UIBarButtonItem) {
        let jsonObject: [String: AnyObject] = [
            "operation":"AcceptOffer",
            "postID":postID,
            "username":username
        ]
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): result = " + String(jsonObject))
        getResultFromServerAsJSONObject(jsonObject)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //func
    @IBAction func gotoProfile(sender: UIButton) {
        let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("profile") as! ProfileVC
        profileVC.isSelf = false
        profileVC.username_value = username
        presentViewController(profileVC, animated: true, completion: nil)
    }
    
    //func
    func sendNotification(username: String, msg: String){
        let jsonObject: [String: AnyObject] = [
            "operation" : "PostNotifications",
            "postID" : postID,
            "username" : username,
            "msg" : msg
        ]
        getResultFromServerAsJSONObject(jsonObject)
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
