//
//  FeedTableViewController.swift
//  InstaGreen
//
//  Created by Madushani Lekam Wasam Liyanage on 2/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewController: UITableViewController {
    private let reuseIdentifier = "feedCell"
    var databaseRef: FIRDatabaseReference!
    var posts: [Post] = []
    var num = 3
    
    var randomUsers = ["flowerFreak", "some dude", "another person", "garden awesome"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Posts"
        //let uid = FIRAuth.auth()?.currentUser?.uid
        self.databaseRef = FIRDatabase.database().reference().child("FeedPosts")
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        posts.removeAll()
        getPosts()
        dump("posts >>>> \(self.posts)")
        
    }

    //MARK: - Fetch data from FB
    func getPosts() {
        self.databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String: String] {
                    let post = Post(userId: valueDict["userId"] ?? "", comment: valueDict["comment"] ?? "", key: snap.key )
                    self.posts.append(post)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func likeImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("liked image")
        
      
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FeedTableViewCell
        cell.gardenImageView.image = nil
        let post = posts[indexPath.row]
        cell.commentLabel.text = post.comment
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let spaceRef = storageRef.child("images/\(post.key)")
        spaceRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                cell.gardenImageView.image = image
            }
        }
        cell.likesLabel.text = "\(self.num) likes"
        cell.profileImageView.image = UIImage(named: "flower")
        
        //names
        let index = Int(arc4random_uniform(UInt32(randomUsers.count)) + 1)
        cell.userNameLabel.text = randomUsers[0]
        
        
        //like imageview
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeImageTapped(tapGestureRecognizer:)))
        cell.likedImage.isUserInteractionEnabled = true
        cell.likedImage.addGestureRecognizer(tapGestureRecognizer)
        

        return cell
    }
    
   
 

 

}
