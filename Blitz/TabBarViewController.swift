//
//  TabBarViewController.swift
//  Blitz
//
//  Created by Tianyang Yu on 10/27/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    @IBOutlet weak var mainTabBar: MainTabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addChildViewControllers()
        
        mainTabBar.TabBarButton.addTarget(self, action: "composeButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addChildViewControllers() {
        self.tabBar.tintColor = UIColor.orangeColor()

        
    }
    
    func composeButtonClick(){
        print(__FUNCTION__)
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


