//
//  EditProfileViewController.swift
//  Parstagram
//
//  Created by Kurtis Hoang on 3/13/19.
//  Copyright © 2019 Kurtis Hoang. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class EditProfileViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //rounds the descriptionField
        descriptionTextView.layer.cornerRadius = 10.0
        //same border color as textfields
        let borderColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        //set border color and border width
        descriptionTextView.layer.borderColor = borderColor.cgColor
        descriptionTextView.layer.borderWidth = 1.0
        //add text and change the text color
        descriptionTextView.text = "Add your profile description here."
        descriptionTextView.textColor = UIColor.lightGray
        //allow UITextViewDelegate
        descriptionTextView.delegate = self
    }
    
    //when starting to write in textView
    func textViewDidBeginEditing(_ textView: UITextView) {
        //if text == placeholder text, empty the textView and change color
        if(descriptionTextView.text == "Add your profile description here.")
        {
            descriptionTextView.text = ""
            descriptionTextView.textColor = UIColor.black
        }
    }
    
    //when finishing textView
    func textViewDidEndEditing(_ textView: UITextView) {
        //if empty put placeholder description and change color
        if(descriptionTextView.text == "")
        {
            descriptionTextView.text = "Add your profile description here."
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func onApplyButton(_ sender: Any) {
        
        let user = PFUser.current()!
        
        //add to database
        if(nameTextField.text != "")
        {
            user["name"] = nameTextField.text
        }
        
        if(descriptionTextView.text != "Add your profile description here.")
        {
            user["desc"] = descriptionTextView.text
        }
        
        if(profileImageView.image != UIImage(named: "profile_tab"))
        {
            //get image data //saved as png
            let imageData = profileImageView.image!.pngData()
            let file = PFFileObject(data: imageData!)
            
            user["image"] = file
        }
        
        user.saveInBackground { (success, error) in
            if success {
                print("saved!")
                
                //create alertbox
                let alert = UIAlertController(title: "Profile!", message: "User profile has just been updated!", preferredStyle: .alert)
                
                //okay button
                let okayButton = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                
                //add button to alertbox and present it
                alert.addAction(okayButton)
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                print("error!")
            }
        }
    }
    
    @IBAction func tappedImage(_ sender: Any) {
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
        
        profileImageView.image = scaledImage
        
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
