//
//  ShowPostVC.swift
//  Blitz
//
//  Created by ccccccc on 15/11/4.
//  Copyright © 2015年 cs490. All rights reserved.
//

import UIKit
import MapKit

class ShowPostVC: UIViewController,
    UIScrollViewDelegate,
    UITextFieldDelegate,
    MKMapViewDelegate
{
    
    // MARK: - Reference Outlet
    @IBOutlet weak var PostTitleLabel: UILabel!
    @IBOutlet weak var BountyLabel: UILabel!
    @IBOutlet weak var QuantityLabel: UILabel!
    @IBOutlet weak var DescrTxt: UITextView!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var PostTime: UILabel!
    @IBOutlet weak var DeleteButton: UIButton!
    
    // MARK: - Variable
    var postdata:JSON = []
    var postID:String = ""
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width, 790)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        requestData()
        DeleteButton.hidden = true

        let post:JSON = postdata["object"]
        PostTitleLabel.text = post["title"].string!

        // Convert GMT time from server into local time
        let date_iso8601 = NSDate.date(fromString: post["postTime"].string!, format: DateFormat.ISO8601)
        let date_String = date_iso8601?.toString(format: DateFormat.Custom("yyyy-MM-dd HH:mm"))
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): local time = %@", date_String!)
        
        PostTime.text = date_String
        if let description = post["description"].string{
            DescrTxt.text = description
        }
        
        let bounty:String = String(post["bounty"].number!)
        BountyLabel.text = bounty
        QuantityLabel.text = String(post["quantity"].number!)
        
        let username:NSString = prefs.stringForKey("USERNAME")!
        if(username.isEqualToString(post["username"].string!)){
            DeleteButton.hidden = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestData(){
        let input: [String: AnyObject] = [
            "operation": "GetPostDetail",
            "postID": postID
        ]
        
        let result = getResultFromServerAsJSONObject(input)
        
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): result = " + String(result))
        
        postdata = JSON(result)
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject) {
        print("Setting Button tapped")
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
