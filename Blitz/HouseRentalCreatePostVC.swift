//
//  HouseRentalCreatePostVC.swift
//  Blitz
//
//  Created by Tianyang Yu on 12/9/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit

class HouseRentalCreatePostVC: PostSubviewVCInterface {
    
    // MARK: - Variables
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "foodDiscoverMapView"
        {
            
        }
    }
    
    override func getAllInformation() -> [String: AnyObject] {
        return [
            :
        ]
    }
}
