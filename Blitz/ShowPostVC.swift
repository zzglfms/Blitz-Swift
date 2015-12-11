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
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var BountyLabel: UILabel!
    @IBOutlet weak var QuantityLabel: UILabel!
    @IBOutlet weak var DescrTxt: UITextView!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var PostTime: UILabel!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Variable
    var postdata:JSON = []
    var postID:String = ""
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var username:NSString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width, 790)
        username = prefs.stringForKey("USERNAME")!
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        requestData()
        DeleteButton.hidden = true

        let post:JSON = postdata["object"]
        setRightButtion(post)
        
        PostTitleLabel.text = post["title"].string!

        // Convert GMT time from server into local time
        let date_iso8601 = NSDate.date(fromString: post["postTime"].string!, format: DateFormat.ISO8601)
        let date_String = date_iso8601?.toString(format: DateFormat.Custom("yyyy-MM-dd HH:mm"))
        //NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): local time = %@", date_String!)
        
        PostTime.text = date_String
        if let description = post["description"].string {
            DescrTxt.text = description
        }
        
        let bounty:String = String(post["bounty"].number!)
        BountyLabel.text = bounty
        QuantityLabel.text = String(post["quantity"].number!)
        
        if(username.isEqualToString(post["username"].string!)){
            DeleteButton.hidden = false
        }
        
        categoryLabel.text = post["category"].string!

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
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): result = Delete this post")
        let input: [String: AnyObject] = [
            "operation": "DeletePost",
            "postID": postID
        ]
        let result = getResultFromServerAsJSONObject(input)
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): result = " + String(result))
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initTableView(){
        let responseTable = self.storyboard?.instantiateViewControllerWithIdentifier("responseTableVC") as! responseTableVC
        responseTable.postID = postID
        let responses:JSON = postdata["object"]["response"]
        responseTable.responses = responses
        self.navigationController?.pushViewController(responseTable, animated: true)
    }
    
    func initResponseView(){
        let responseEditVC = self.storyboard?.instantiateViewControllerWithIdentifier("responseView") as! Blitz.responseEditVC
        responseEditVC.isOwner = false
        responseEditVC.postID = postID
        self.navigationController?.pushViewController(responseEditVC, animated: true)
    }
    
    func clickByOwner(sender:UIButton!)
    {
        let bool = postdata["object"]["TransactionCompleted"].number
        if bool == 0 {
            initTableView()

        }
        else {
            let alertController = UIAlertController(title: "Alter!", message:
                "This Transaction has been Completed!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }

    }
    
    func clickByViewer(sender:UIButton!)
    {
        let bool = postdata["object"]["TransactionCompleted"].number
        if bool == 0 {
            initResponseView()
        }else{
            let alertController = UIAlertController(title: "Alter!", message:
                "This Transaction has been Completed!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    func setRightButtion(post: JSON){
        let button = UIButton()
        
        if(username.isEqualToString(post["username"].string!)){
            button.setTitle("view replys", forState: .Normal)
            button.addTarget(self, action: "clickByOwner:", forControlEvents: .TouchUpInside)
            button.frame = CGRectMake( -50, -40, 100, 500)

        }else{
            button.setTitle("reply", forState: .Normal)
            button.addTarget(self, action: "clickByViewer:", forControlEvents: .TouchUpInside)
            button.frame = CGRectMake( -50, -40, 60, 500)
        }
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)

    }

}
