//
//  RegisterViewController.swift
//  InstaGreen
//
//  Created by Ilmira Estil on 2/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    var databaseRef: FIRDatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    @IBAction func finishRegsiter(_ sender: UIButton) {
        let ref = FIRDatabase.database().reference().child("users").childByAutoId()
        if let name = name.text, let email = email.text, let password = password.text {
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    print("User Creating Error \(error.localizedDescription)")
                    let alertController = showAlert(title: "Signup Failed!", message: "Failed to Register. Please Try Again!")
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    let values = ["name": name, "email": email]
                    
                    ref.setValue(values) {(error, reference) in
                        if let error = error {
                            print(error)
                            
                            //alert
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let tbvc = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
                            let alertController = showAlert(title: "Signup Successful!", message: "Successfully Registered.")
                            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                self.present(tbvc, animated: true, completion: nil)
                            }))
                            
                            //automatically login user:
                            FIRAuth.auth()?.signIn(withEmail: self.email.text!, password: self.password.text!, completion: nil)
                        }
                    }
                }
            })
        }
    }
    
    
    
    
}
