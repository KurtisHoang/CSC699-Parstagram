//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Kurtis Hoang on 3/5/19.
//  Copyright © 2019 Kurtis Hoang. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postTableView: UITableView!
    
    var posts = [PFObject]()
    
    var numOfPost: Int = 4
    var myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postTableView.delegate = self
        postTableView.dataSource = self
        
        loadPost()
        
        //tie an action to myRefreshControl
        myRefreshControl.addTarget(self, action: #selector(loadPost), for: .valueChanged)
        //set tableview's refreshcontrol
        postTableView.refreshControl = myRefreshControl
        //automatic cell height
        self.postTableView.rowHeight = UITableView.automaticDimension
        self.postTableView.estimatedRowHeight = 200
    }
    
    @objc func loadPost()
    {
        self.posts.removeAll()
        
        let query = PFQuery(className:"Posts")
        //fetches the author //if you don't have this it will have the pointer to the author
        query.includeKey("author")
        //get last 20
        query.limit = numOfPost
        query.addDescendingOrder("createdAt")
        
        //get db
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                //set post to local post
                self.posts = posts!
                //reload tableview
                self.postTableView.reloadData()
            }
            else
            {
                print("Error: \(error?.localizedDescription)")
            }
        }
        
        //end refresh
        self.myRefreshControl.endRefreshing()
    }
    
    func loadMorePosts() {
        
        self.posts.removeAll()
        
        let query = PFQuery(className:"Posts")
        //fetches the author //if you don't have this it will have the pointer to the author
        query.includeKey("author")
        numOfPost += 20
        //get last 20
        query.limit = numOfPost
        query.addDescendingOrder("createdAt")
        
        //get db
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                //set post to local post
                self.posts = posts!
                //reload tableview
                self.postTableView.reloadData()
            }
            else
            {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //check if at the last cell
        if indexPath.row + 1 == posts.count {
            loadMorePosts()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = postTableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        cell.captionLabel.text = post["caption"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        //go to info.plist, open as source code
        //add this to the end to allow http than htts
        /*
         <key>NSAppTransportSecurity</key>
         <dict>
         <key>NSAllowsArbitraryLoads</key><true/>
         </dict>
         */
        
        cell.photoView.af_setImage(withURL: url)
        
        return cell
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
