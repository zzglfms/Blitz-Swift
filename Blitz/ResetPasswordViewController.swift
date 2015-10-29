//
//  ResetPasswordViewController.swift
//  Blitz
//
//  Created by ccccccc on 15/10/6.
//  Copyright © 2015年 cs490. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func restTapped(sender: UIButton) {
        let username:NSString = txtUsername.text!
        let email:NSString = txtEmail.text!
        
        if (username.isEqualToString("") || email.isEqualToString("")){
            let alertController = UIAlertController(title: "Rest Password Failed!", message: "Please enter Username and Email", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {}
        }else{
            //connect server
            NSLog("@ResetPasswordViewController.swift: username = %@, email = %@", username, email)
            
            let jsonObject: [String: AnyObject] = [
                "operation": "ForgetPassword",
                "username": username
            ]
            
            let result = request(jsonObject)
            
            NSLog("@SignupViewController.swift: Result: %@", result);
        }
    }


    @IBAction func goToLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
