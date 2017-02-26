//
//  ProfileViewController.swift
//  InstaGreen
//
//  Created by Madushani Lekam Wasam Liyanage on 2/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

//Global Variable to have access throughout the app
let imageCache = NSCache<AnyObject, AnyObject>()

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
 
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var uploadedImagesCollectionView: UICollectionView!
    
    
    
    let picker = UIImagePickerController()
    var images: [UIImage] = [UIImage(named: "nature")!, UIImage(named: "tree")!]
    var userProfileImageReference: FIRDatabaseReference!
    var userUploadsReference: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImageButton.setImage(UIImage(named: "default"), for: .normal)
        self.likesLabel.text = "5💚"
        self.rankLabel.text = "Seedling"
        self.postsLabel.text = "Your uploads"
        checkUser()
        uploadedImagesCollectionView.delegate = self
        uploadedImagesCollectionView.dataSource = self
        userProfileImageReference = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
        userUploadsReference = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("uploads")
        
    }

    
    func checkUser() {
        if (FIRAuth.auth()?.currentUser?.isAnonymous)! {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let lvc = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            let tbvc = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
            let alertController = UIAlertController(title: "Login Required!", message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.present(lvc, animated: true, completion: nil)
            }))
            alertController.addAction(UIAlertAction(title: "Back", style: .default, handler: { (action: UIAlertAction!) in
                self.present(tbvc, animated: true, completion: nil)
            }))
        } else {
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        checkUser()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! UploadedImagesCollectionViewCell
        cell.uploadedImageView.image = nil
        cell.uploadedImageView.image = self.images[indexPath.row]
        cell.setNeedsLayout()
        
        return cell

    }

    // MARK: - Download Image Tasks
    func downloadProfileImage() {
        //Fetch User Profile Image
        self.userProfileImageReference.observe(.childAdded, with: { (snapshot) in
            
            if snapshot.key == "profileImageURL" {
                let downloadURL = snapshot.value as! String
                
                //Check cache for profile image
                if let cachedProfilePic = imageCache.object(forKey: downloadURL as AnyObject) {
                    DispatchQueue.main.async {
                        let image = cachedProfilePic as? UIImage
                        self.profileImageButton.setImage(image, for: .normal)
                    }
                    return
                }
                
                //Download Image If Not Found In Cache. Insert into cache as well
                let storageRef = FIRStorage.storage().reference(forURL: downloadURL)
                
                storageRef.data(withMaxSize: 1 * 2000 * 2000) { (data, error) -> Void in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    if let data = data {
                        DispatchQueue.main.async {
                            let pic = UIImage(data: data)
                            imageCache.setObject(pic!, forKey: downloadURL as AnyObject)
                            self.profileImageButton.setImage(pic, for: .normal)
                        }
                    }
                }
            }
        })
    }
    
    func downloadUserUploads() {
        
        //Downloads User Uploads
        self.userUploadsReference.observe(.childAdded, with: { (snapshot) in
            // Get download URL from snapshot
            let downloadURL = snapshot.value as! String
            
            //Check cache for images
            if let cachedImage = imageCache.object(forKey: downloadURL as AnyObject) as? UIImage {
                self.images.append(cachedImage)
                DispatchQueue.main.async {
                    self.uploadedImagesCollectionView.reloadData()
                }
                return
            }
            
            // Create a storage reference from the URL
            let storageRef = FIRStorage.storage().reference(forURL: downloadURL)
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                if let data = data {
                    let pic = UIImage(data: data)
                    imageCache.setObject(pic!, forKey: downloadURL as AnyObject)
                    self.images.append(pic!)
                }
                DispatchQueue.main.async {
                    self.uploadedImagesCollectionView.reloadData()
                }
            }
            
        })
    }
    
//    //Table View Methods
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return userVotes.count
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierTableView, for: indexPath) as! VotersFeedTableViewCell
//        
//        cell.textLabel?.text = userVotes[indexPath.row]
//        
//        return cell
//    }

//    func populateUserVoteArray () {
//        let userReference = FIRDatabase.database().reference().child("users").child(user!).child("upvotes")
//        
//        userReference.observe(.childAdded, with: { (snapshot) in
//            
//            if snapshot.key == "upvote" {
//                
//                self.userVotes.append("You upvoted \(snapshot.value as! String)")
//                
//            }
//            
//            if snapshot.key == "downvote" {
//                self.userVotes.append("You downvoted \(snapshot.value as! String)")
//            }
//            
//            DispatchQueue.main.async {
//                self.userTableView.reloadData()
//            }
//        })
//        
//    }


    
    // Handler Function for picking profile pic
    func pickProfileImage() {
        let picker = UIImagePickerController()
        present(picker, animated: true, completion: nil)
        picker.delegate = self
    }
    
    // MARK: - Image Picker Delegate Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(info["UIImagePickerControllerOriginalImage"] as! UIImage) {
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if let metadataURL = metadata?.downloadURL()?.absoluteString {
                    let values = [
                        "profileImageURL" : metadataURL
                    ]
                    FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(values)
                }
            })
        }
        
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage?
        profileImageButton.setImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profileImageButtonTapped(_ sender: UIButton) {
    }

    
    //MARK: - Utilities
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        print("clicked logout")
            do{
                try FIRAuth.auth()?.signOut()
            }
            catch{
                let alertController = UIAlertController(title: "Error", message: "Trouble Logging Out", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            // let _ = self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.popViewController(animated: true)
        
    }
    
}
