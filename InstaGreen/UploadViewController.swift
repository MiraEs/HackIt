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
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var uploadButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
    }

    //MARK: - Upload function
    @IBAction func uploadTapped(_ sender: UIButton) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    

    //MARK: - Upload to firebase

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
    }
 
    
    //MARK: - Set up picker funcitons
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.uploadButton.imageView?.contentMode = .scaleAspectFit
            self.uploadButton.setImage(image, for: .normal)
            dump(image)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }

}
