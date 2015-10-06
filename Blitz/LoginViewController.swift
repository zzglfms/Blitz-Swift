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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let post:String = "username=\(username)&password=\(password)"
            
            NSLog("PostData: %@",post);
            
            let result = request(post)
            
            NSLog("Result: %@", result);
            
            if(result == "Success"){
                NSLog("Login SUCCESS");
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else{
                let alertController = UIAlertController(title: "Sign Up Failed!", message: "Server reply fail", preferredStyle: .Alert)
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
