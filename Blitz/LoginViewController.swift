//
//  LoginViewController.swift
//  Blitz
//
//  Created by ccccccc on 15/10/4.
//  Copyright © 2015年 cs490. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var window: UIWindow?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if(true){
            self.performSegueWithIdentifier("Login", sender: self)
            NSLog("@LoginViewController.swfit: Should jump to homepage")
        }
    }
    
    
    @IBAction func signinTapped(sender: UIButton) {
        // Authentication Code
        let username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            let alertController = UIAlertController(title: "Sign Up Failed!", message: "Please enter Username and Password", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {}
        } else {
            
            // Make a json object for communication with server
            let jsonObject: [String: AnyObject] = [
                "operation": "Login",
                "username": username,
                "password": password
            ]
            
            let result = request(jsonObject)
            
            NSLog("@LoginViewController.swift: Result: %@", result);
            
            if(result["success"] as! Bool){
                NSLog("@SignupViewController.swift: Login SUCCESS");
                
                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                prefs.setObject(username, forKey: "USERNAME")
                prefs.setInteger(1, forKey: "ISLOGGEDIN")
                prefs.synchronize()
                
                self.performSegueWithIdentifier("Login", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Sign Up Failed!", message: result["msg"] as? String, preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true) {}
            }
            
        }
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
