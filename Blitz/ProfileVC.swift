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
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var avatarImage:UIImageView!
    @IBOutlet var header:UIView!
    @IBOutlet var headerLabel:UILabel!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBlurImageView:UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    var blurredHeaderImageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        ratingView.editable = false
        localStroageRead()
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
    
    func localStroageRead(){
        //local data read
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let username = prefs.stringForKey("USERNAME"){
            labelUsername.text = username
        }
        
        if let imageData = prefs.objectForKey("avatar")as? NSData{
            let image = UIImage.init(data: imageData)
            avatarImage.image = image
        } else {
            //fetch image from server
        }
        
        
    }

    @IBAction func rating_value_change(sender: HCSStarRatingView) {
        NSLog("@Changed rating to %.1f", sender.value);
    }
    
}