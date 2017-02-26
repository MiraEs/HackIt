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
    var databaseRef: FIRDatabaseReference!
    var posts = [Post]()
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var gardenImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        posts.removeAll()
//        getPosts()
//        self.tableView.reloadData()
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableViewAutomaticDimension
//        dump("posts >>>> \(self.posts)")
//    }

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
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return posts.count
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let post = posts[indexPath.row]
        // Configure the cell...
        //cell.commentLabel.text = post.comment
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let spaceRef = storageRef.child("images/\(post.key)")
        spaceRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
//                self.gardenImageView.image = image
            }
        }

        return cell
    }
 

 

}
