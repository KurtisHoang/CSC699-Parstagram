//
//  ViewController.swift
//  Parstagram
//
//  Created by Kurtis Hoang on 3/4/19.
//  Copyright © 2019 Kurtis Hoang. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onSignIn(_ sender: Any) {
        //set username and password
        let username = usernameField.text
        let password = passwordField.text
        
        //parse login
        PFUser.logInWithUsername(inBackground: username!, password: password!) { (user, error) in
            if (user != nil)
            {
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
            else
            {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        //set user data to parse
        var user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
//        // can have other information
//        user.email = "email@example.com"
//        // other fields can be set just like with PFObject
//        user["phone"] = "415-392-0202"
        
        //sign up
        user.signUpInBackground { (success, error) in
            
            if(success)
            {
                //if success move to feed screen
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
            else
            {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

