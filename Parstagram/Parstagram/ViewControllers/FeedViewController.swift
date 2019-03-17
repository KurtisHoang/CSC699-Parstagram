//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Kurtis Hoang on 3/5/19.
//  Copyright © 2019 Kurtis Hoang. All rights reserved.
//

import UIKit
import Parse
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {

    @IBOutlet weak var postTableView: UITableView!
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    var selectedPost: PFObject!
    
    var posts = [PFObject]()
    
    var numOfPost: Int = 20
    
    var myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postTableView.delegate = self
        postTableView.dataSource = self
        
        //add place holder and button title
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        //need MessageInputBarDelegate
        commentBar.delegate = self
        
        //dismiss the keyboard by dragging down on the tableview
        postTableView.keyboardDismissMode = .interactive
        
        //
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        //added comments so includeKeys* instead of includeKey
        query.includeKeys(["author","comments", "comments.author"])
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
        query.includeKeys(["author","comments", "comments.author"])
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
        if indexPath.section + 1 == posts.count {
            loadMorePosts()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //get posts by current section
        let post = posts[section]
        //get comments from post
        // ?? [], if nil it will be []
        let comments = (post["comments"] as? [PFObject]) ?? []
        //display comments + the main post (1) + comment cell (1)
        return comments.count + 2
    }
    
    //added new cell to storyboard
    //so we go through section (post + comments)
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //get post and comments
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        //post cell is the first row
        if indexPath.row == 0 {
            let cell = postTableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            
            let user = post["author"] as! PFUser
            cell.usernameLabel.text = user.username
            cell.captionLabel.text = post["caption"] as? String
            
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
            
            if(user["image"] != nil)
            {
                let imgFile = user["image"] as! PFFileObject
                let urlStr = imgFile.url!
                let profileUrl = URL(string: urlStr)
                cell.profileImage.af_setImage(withURL: profileUrl!)
            }
            
            cell.photoView.af_setImage(withURL: url)
            
            return cell
        }
        //
        else if indexPath.row <= comments.count
        {
            let cell = postTableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            if(user["image"] != nil)
            {
                let imgFile = user["image"] as! PFFileObject
                let urlStr = imgFile.url!
                let profileUrl = URL(string: urlStr)
                cell.profileImage.af_setImage(withURL: profileUrl!)
            }
            
            return cell
        }
        else
        {
            let cell = postTableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //row that is selected
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            //show the commentBar
            commentBar.inputTextView.becomeFirstResponder()
            
            //save current post
            selectedPost = post
        }
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        //logout
        PFUser.logOut()
        
        //get main storyboard
        let main = UIStoryboard(name: "Main", bundle: nil)
        //get loginViewController from main storyboard
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        //access to delegate from AppDelegate
        let delegate = UIApplication.shared.delegate as! AppDelegate
        //change root VC to login VC
        delegate.window?.rootViewController = loginViewController
    }
    
    //Any func below will be for MessageInputBar
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //create the comment
        let comment = PFObject(className: "Comments")
                comment["text"] = commentBar.inputTextView.text
                comment["post"] = selectedPost
                comment["author"] = PFUser.current()!
        
                //add comment to post
                selectedPost.add(comment, forKey: "comments")
        
                selectedPost.saveInBackground { (success, error) in
                    if success {
                        print("Comment saved")
                    }
                    else {
                        print("Error saving comment")
                    }
                }
        
        postTableView.reloadData()
        
        //clear and dismiss the input bar
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    
    @objc func keyboardWillBeHidden(note: Notification)
    {
        //set commentBar inputTextView text to nil
        //don't show comment bar
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    //Any func above will be for MessageInputBar
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
