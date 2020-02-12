//
//  RegistrationViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField! {
        didSet {
            self.firstNameTextField.placeholder = String.localize("registration_first_name")
        }
    }

    @IBOutlet weak var lastNameTextField: UITextField! {
        didSet {
            self.lastNameTextField.placeholder = String.localize("registration_last_name")
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            self.emailTextField.placeholder = String.localize("registration_email")
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField.placeholder = String.localize("registration_password")
        }
    }
    
    @IBOutlet weak var passwordRetypeTextField: UITextField! {
        didSet {
            self.passwordRetypeTextField.placeholder = String.localize("registration_retype_password")
        }
    }
    
    @IBOutlet weak var createAccountButton: UIButton! {
        didSet {
            self.createAccountButton.setTitle(String.localize("registration_create_account"), for: .normal)
            self.createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButon), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func didTapCreateAccountButon() {
        let createAccountManager = FirebaseAuthManager()
        if let email = self.emailTextField.text, let password = self.passwordTextField.text {
            createAccountManager.createUser(email: email, password: password) { [weak self](success) in
                var message = ""
                if success {
                    message = "User Succefully created!"
                } else {
                    message = "There was a error!"
                }
                
                let alertViewController = UIAlertController(title: "Response", message: message, preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                    if success {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }))
                self?.navigationController?.present(alertViewController, animated: true, completion: nil)
            }
        }
    }
}
