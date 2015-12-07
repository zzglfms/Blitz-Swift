//
//  FoodDiscoverPostVC.swift
//  Blitz
//
//  Created by Tianyang Yu on 12/7/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit

class FoodDiscoverPostVC: PostSubviewVCInterface {
    
    // MARK: - Variables
    var mapVC: MapVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapVC.addressTitle.text = "Location:"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "foodDiscoverMapView"
        {
            mapVC = segue.destinationViewController as! MapVC
        }
    }
    
    override func getAllInformation() -> [String: AnyObject] {
        return [
            "location": mapVC.addressTextField.text!,
        ]
    }
}
