//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Kurtis Hoang on 3/5/19.
//  Copyright © 2019 Kurtis Hoang. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let post = PFObject(className: "Posts")
        
        //add to database
        post["caption"] = commentField.text
        post["author"] = PFUser.current()!
        
        //get image data //saved as png
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success {
                print("saved!")
                
                //create alertbox
                let alert = UIAlertController(title: "Post posted!", message: "You have posted your image!", preferredStyle: .alert)
                
                //okay button
                let okayButton = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                
                //add button to alertbox and present it
                alert.addAction(okayButton)
                self.present(alert, animated: true, completion: nil)
                
                //reset
                self.commentField.text = ""
                self.imageView.image = UIImage(named: "image_placeholder")
            }
            else
            {
                print("error!")
            }
        }
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        //call back with the photo
        picker.delegate = self
        //tweak the photo after taking the photo
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        else
        {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
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
