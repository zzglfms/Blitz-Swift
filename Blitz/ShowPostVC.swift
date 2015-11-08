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
    
    //reference Outlet
    @IBOutlet weak var PostTitleLabel: UILabel!
    @IBOutlet weak var BountyLabel: UILabel!
    @IBOutlet weak var QuantityLabel: UILabel!
    @IBOutlet weak var DescrTxt: UITextView!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var PostTime: UILabel!
    
    
    //variable
    var postdata:JSON = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width, 790)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        let post:JSON = postdata["object"]
        PostTitleLabel.text = post["title"].string!
        PostTitleLabel.text = post["title"].string!

        let date_iso8601 = NSDate.date(fromString: post["postTime"].string!, format: DateFormat.ISO8601)
        let date_String = date_iso8601?.toString(format: DateFormat.Custom("yyyy-MM-dd HH:mm"))
        print("this is date:", date_String!)
        
        PostTime.text = date_String
        DescrTxt.text = post["description"].string!
        let bounty:String = String(post["bounty"].number!)
        BountyLabel.text = bounty
        QuantityLabel.text = String(post["quantity"].number!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func chattest(){ // this func could sent the message
//        //create PFObject
//        let message = PFObject(className:"Message")
//        message["Text"] = "wo ri le gou"
//        message.saveInBackgroundWithBlock {
//            (success: Bool, error: NSError?) -> Void in
//            if (success) {
//                // The object has been saved.
//                //TODO: Retrieve the message
//            } else {
//                // There was a problem, check error.description
//                NSLog(error!.description)
//            }
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
