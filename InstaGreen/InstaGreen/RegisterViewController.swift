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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func finishRegsiter(_ sender: UIButton) {
        if let name = name.text, let email = email.text, let password = password.text {
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    print("User Creating Error \(error.localizedDescription)")
                    let alertController = showAlert(title: "Signup Failed!", message: "Failed to Register. Please Try Again!")
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    let alertController = showAlert(title: "Signup Successful!", message: "Successfully Registered. Please Login to Use Our App!")
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    
}
