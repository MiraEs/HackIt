//
//  LoginViewController.swift
//  InstaGreen
//
//  Created by Madushani Lekam Wasam Liyanage on 2/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButton = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    print("User Login Error \(error.localizedDescription)")
                    let alertController = showAlert(title: "Login Failed!", message: "Failed to Login. Please Check Your Email and Password!")
                    
                    self.present(alertController, animated: true, completion: nil)
                    self.clearTextFields()
                }
                else {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tbvc = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
                    let alertController = UIAlertController(title: "Login Successful!", message: nil, preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                    self.clearTextFields()
                    
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        self.present(tbvc, animated: true, completion: nil)
                    }))
                    
                }
            })
        }
        
        
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    print("User Creating Error \(error.localizedDescription)")
                    let alertController = showAlert(title: "Signup Failed!", message: "Failed to Register. Please Try Again!")
                    self.present(alertController, animated: true, completion: nil)
                    self.clearTextFields()
                }
                else {
                    let alertController = showAlert(title: "Signup Successful!", message: "Successfully Registered. Please Login to Use Our App!")
                    self.present(alertController, animated: true, completion: nil)
                    self.clearTextFields()
                }
            })
        }
        
    }
    
    func clearTextFields() {
        emailTextField.text = nil
        passwordTextField.text = nil
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - buttons
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("cancel", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
  
    
}

public func showAlert(title: String, message: String?) -> UIAlertController {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    
    return alertController
}
