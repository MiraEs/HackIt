//
//  UploadViewController.swift
//  InstaGreen
//
//  Created by Madushani Lekam Wasam Liyanage on 2/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    //private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        chooseImage()
    }

    //MARK: - Firebase
    /*
    internal func upload(){
        
        guard let imageToUpload = selectedImage else {
            self.showAlert(title: "Please select an image"); return }
        
        let comment = commentTextView.text.trimmingCharacters(in: CharacterSet.whitespaces)
        
        guard comment != "" else { self.showAlert(title: "Please add a comment"); return}
        guard let userId = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let databaseRef = FIRDatabase.database().reference().child("posts")
        let childRef = databaseRef.childByAutoId()
        let storageRef = FIRStorage.storage().reference(forURL: "gs://ac-32-final.appspot.com")
        let imageRef = storageRef.child("images/\(childRef.key)")
        let postDic = ["userId": userId,"comment":comment]
        
        childRef.setValue(postDic) { (error, ref) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                print("post added")
            }
        }
        
        guard let imageData = UIImageJPEGRepresentation(imageToUpload, 0.5) else { return }
        
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        imageRef.put(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error{
                self.showAlert(title: "Upload Failed!", message: error.localizedDescription)
            }else{
                self.showAlert(title: "Photo uploaded!")
                self.selectedImage = nil
            }
        }
    }
 */
    
    //MARK: - Image picker delegates
    func chooseImage() {
        print("Upload an image")
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            //self.uploadImageView.contentMode = .scaleAspectFit
            //self.uploadImageView.image = image
            dump("IMAGE >>> \(image)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
 

}
