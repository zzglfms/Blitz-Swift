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
    var post:JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width, 790)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        print(post)
        PostTitleLabel.text = post["title"].string!
        PostTime.text = post["postTime"].string!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
