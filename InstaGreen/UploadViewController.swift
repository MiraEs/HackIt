//
//  UploadViewController.swift
//  InstaGreen
//
//  Created by Madushani Lekam Wasam Liyanage on 2/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation



class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    let picker = UIImagePickerController()
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var uploadButton: UIButton!
    
    var databaseRef: FIRDatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseRef = FIRDatabase.database().reference().child("FeedPosts")
        picker.delegate = self
        commentTextView.delegate = self
        commentTextView.text = "Add a description.."
        commentTextView.textColor = UIColor.lightGray
        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        loginAnonymously()
    }
    
    //MARK: - MOVE THESE FUNCTIONS
    func loginAnonymously() {
        FIRAuth.auth()?.signInAnonymously(completion: { (user: FIRUser?, error: Error?) in
            
            if error != nil {
                print("Error attempting to log in anonymously: \(error!)")
            }
            if user != nil {
                print("Signed in anonymously!")
                
                 //self.shouldPerformSegue(withIdentifier: self.segue, sender: self)
            }
        })
        
    }

    //MARK: - Upload function
    @IBAction func uploadTapped(_ sender: UIButton) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    

    //MARK: - Upload to firebase
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        addToFB()
    }
    
    func addToFB() {
        //stored to storage
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let comment = commentTextView.text else { return }
        let linkRef = self.databaseRef.childByAutoId()
        let storageRef = FIRStorage.storage().reference().child("images").child(linkRef.key)
        
        if let uploadData = UIImageJPEGRepresentation(self.uploadButton.currentImage!, 0.5) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                //stored to database
                let values = ["userId": uid, "comment": comment]
                
                linkRef.setValue(values) { (error, reference) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print(reference)
                        let alert = UIAlertController(title: "Upload Success!", message: nil, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                        //self.dismiss(animated: true, completion: nil)
                    }
                }
                
            })
        }
    }
 
    //MARK: - Set up picker funcitons
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.uploadButton.imageView?.contentMode = .scaleAspectFit
            self.uploadButton.setImage(image, for: .normal)
            dump(image)
            
          //photo location??
        
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentTextView.textColor == UIColor.lightGray {
            commentTextView.text = nil
            commentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add a description.."
            textView.textColor = UIColor.lightGray
        }
    }

}
