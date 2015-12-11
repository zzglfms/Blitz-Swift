//
//  ProfileVC.swift
//  Blitz
//
//  Created by ccccccc on 15/10/27.
//  Copyright © 2015年 cs490. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

class ProfileVC: UIViewController, UIScrollViewDelegate {
    
    //outlet
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var avatarImage:UIImageView!
    @IBOutlet var header:UIView!
    @IBOutlet var headerLabel:UILabel!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBlurImageView:UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    var blurredHeaderImageView:UIImageView?
    @IBOutlet weak var useremail: UILabel!
    @IBOutlet weak var ratingScore: UILabel!
    @IBOutlet weak var logoutButton: TWTButton!
    @IBOutlet weak var editProfileButton: TWTButton!
    @IBOutlet weak var chatButton: TWTButton!
    @IBOutlet weak var backButton: UIButton!
    
    //var
    var isSelf = true
    var username_value = ""
    var postID = "" // for rating
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var localjson: JSON = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        if isSelf {
            getProfile()  // need to ingore if the network lag
            localStroageRead()
            chatButton.hidden = true
            backButton.hidden = true
        }else{
            getProfilefromServer(username_value)
            logoutButton.hidden = true
            editProfileButton.hidden = true
            chatButton.hidden = false

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Header - Image
        
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.image = UIImage(named: "header_bg")
        headerImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)
        
        // Header - Blurred Image
        
        headerBlurImageView = UIImageView(frame: header.bounds)
        headerBlurImageView?.image = UIImage(named: "header_bg")?.blurredImageWithRadius(10, iterations: 20, tintColor: UIColor.clearColor())
        headerBlurImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        headerBlurImageView?.alpha = 0.0
        header.insertSubview(headerBlurImageView, belowSubview: headerLabel)
        
        header.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            header.layer.transform = headerTransform
        }
            
            // SCROLL UP/DOWN ------------
        else {
            
            // Header -----------
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            //  ------------ Label
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerLabel.layer.transform = labelTransform
            headerLabel.text = labelUsername.text
            //  ------------ Blur
            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            // Avatar -----------
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
                if avatarImage.layer.zPosition < header.layer.zPosition{
                    header.layer.zPosition = 0
                }
                
            }else {
                if avatarImage.layer.zPosition >= header.layer.zPosition{
                    header.layer.zPosition = 2
                }
            }
        }
        // Apply Transformations
        header.layer.transform = headerTransform
        avatarImage.layer.transform = avatarTransform
    }
    
    func getProfile(){
        let username:String = prefs.stringForKey("USERNAME")!

        let jsonObject: [String: AnyObject] = [
            "operation": "GetProfile",
            "username": username
        ]
        
        let result = getResultFromServerAsJSONObject(jsonObject)

        let json = JSON(result)
        localjson = JSON(result)
        
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Profile JSON = %@", String(json))
        
        let email:String = json["email"].string!
        let emailnss = email as NSString
        prefs.setObject(emailnss, forKey: "EMAIL")
        
        if let rating:NSNumber = json["rating"].number!{
            prefs.setObject(rating as NSNumber, forKey: "RATING")
        }
        //Server may not have this field for a new user
        if let fullname:String = json["fullname"].string{
            prefs.setObject(fullname as NSString, forKey: "FULLNAME")
        } else {
            NSLog("@ProfileVC: getProfile():%@", json["fullname"].error!)
        }
        
        prefs.synchronize()
    }

    func getProfilefromServer(username: String){
        let jsonObject: [String: AnyObject] = [
            "operation": "GetProfile",
            "username": username
        ]
        ratingView.editable = false

        let result = getResultFromServerAsJSONObject(jsonObject)
        let json = JSON(result)
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Profile JSON = %@", String(json))
        
        let email:String = json["email"].string!
        useremail.text = email
        
        let rating:NSNumber = json["rating"].number!
        let score = String(format: "Score: %.1f", rating.floatValue)
        ratingScore.text = score
        ratingView.value = CGFloat(rating.floatValue)
        
        //fetch from server
        /*let image = UIImage.init(data: imageData)
        avatarImage.image = image*/
        
        labelUsername.text = username
    }
    
    func localStroageRead(){
        //local data read
        ratingView.editable = false
        let ratescore = prefs.objectForKey("RATING")
        let score = String(format: "Score: %.1f", (ratescore?.floatValue)!)
        ratingScore.text = score
        ratingView.value = CGFloat((ratescore?.floatValue)!)
        
        if let username = prefs.stringForKey("USERNAME"){
            labelUsername.text = username
        }
        
        if let imageData = prefs.objectForKey("avatar")as? NSData{
            let image = UIImage.init(data: imageData)
            avatarImage.image = image
        } else {
            //fetch image from server
        }
        
        if let email = prefs.stringForKey("EMAIL"){
            useremail.text = email
        }
        
    }
    
    //
    @IBAction func rating_value_change(sender: HCSStarRatingView) {
        NSLog("@Changed rating to %.1f", sender.value);
        //TODO -- send the value to server
    }
    
    @IBAction func logoutTapped(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        self.performSegueWithIdentifier("Logout", sender: self)
    }
    
    //TODO -- this function to init an chat with two user
    @IBAction func startChat(sender: UIButton){
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Start Chat")
    }
    
    //
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //
    @IBAction func rateTheUser(sender: AnyObject) {
        let alertController = UIAlertController(title: "Rate This User\n\n", message: nil,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let starRatingView: HCSStarRatingView = HCSStarRatingView.init(frame: CGRectMake(50, 50, 180, 20))
        ratingView.editable = false
        starRatingView.accurateHalfStars = true
        starRatingView.maximumValue = 5
        starRatingView.minimumValue = 0
        //let rating:NSNumber = localjson["rating"].number!
        starRatingView.value = CGFloat(1)
        let username = username_value
        
        alertController.view.addSubview(starRatingView)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
            { action -> Void in
                NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Rating Score " +  String(starRatingView.value))
                let jsonObject: [String: AnyObject] = [
                    "operation": "Rate",
                    "username": username,
                    "score": String(starRatingView.value)
                ]
                getResultFromServerAsJSONObject(jsonObject)
            }
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}