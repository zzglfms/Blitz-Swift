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
    var response:JSON = []
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if isOwner { //
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Select", style: .Plain, target: self,
                action: "OwnerSelection:")
            responseTextField.editable = false
            bounty.enabled = false
            responseTextField.text = response["comment"].string
            bounty.text = response["offeredPrice"].number?.stringValue
            //Button
            userButton.setTitle(response["username"].string, forState: UIControlState.Normal)
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
        let username = response["username"].string
        let jsonObject: [String: AnyObject] = [
            "operation":"AcceptOffer",
            "postID":postID,
            "username":username!
        ]
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): result = " + String(jsonObject))
        getResultFromServerAsJSONObject(jsonObject)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //func
    @IBAction func gotoProfile(sender: UIButton) {
        let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("profile") as! ProfileVC
        profileVC.isSelf = false
        profileVC.username_value = response["username"].string!
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
