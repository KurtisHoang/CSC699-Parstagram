//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Kurtis Hoang on 3/13/19.
//  Copyright © 2019 Kurtis Hoang. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var joinedLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let user = PFUser.current()!
        usernameLabel.text = "Username: \(user.username!)"
        if(user["name"] != nil)
        {
            nameLabel.text = "Name: \(user["name"] as! String)"
        }

        //convert date to string
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let myString = formatter.string(from: user.createdAt!)
        let myDate = formatter.date(from: myString)
        formatter.dateFormat = "MMM-dd-yyyy"
        let profileDate = formatter.string(from: myDate!)
        joinedLabel.text = "joined: \(profileDate)"
        
        if(user["desc"] != nil)
        {
            DescriptionLabel.text = "Description: \(user["desc"] as! String)"
        }
        
        if(user["image"] != nil)
        {
            let imageFile = user["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            profileImageView.af_setImage(withURL: url)
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
