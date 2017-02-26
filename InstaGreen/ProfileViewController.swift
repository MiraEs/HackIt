//
//  ProfileViewController.swift
//  InstaGreen
//
//  Created by Madushani Lekam Wasam Liyanage on 2/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var uploadedImagesCollectionView: UICollectionView!
    
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadedImagesCollectionView.delegate = self
        uploadedImagesCollectionView.dataSource = self
        
        checkUser()
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
        
        return UICollectionViewCell()
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
