//
//  RegistrationViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField! {
        didSet {
            self.firstNameTextField.placeholder = String.localize("registration_first_name")
            self.firstNameTextField.layer.borderWidth = 1.0
            self.firstNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    @IBOutlet weak var lastNameTextField: UITextField! {
        didSet {
            self.lastNameTextField.placeholder = String.localize("registration_last_name")
            self.lastNameTextField.layer.borderWidth = 1.0
            self.lastNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            self.emailTextField.placeholder = String.localize("registration_email")
            self.emailTextField.layer.borderWidth = 1.0
            self.emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField.placeholder = String.localize("registration_password")
            self.passwordTextField.layer.borderWidth = 1.0
            self.passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var passwordRetypeTextField: UITextField! {
        didSet {
            self.passwordRetypeTextField.placeholder = String.localize("registration_retype_password")
            self.passwordRetypeTextField.layer.borderWidth = 1.0
            self.passwordRetypeTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var createAccountButton: UIButton! {
        didSet {
            self.createAccountButton.setTitle(String.localize("registration_create_account"), for: .normal)
            self.createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButon), for: .touchUpInside)
            createAccountButton?.layer.cornerRadius = 4.0
        }
    }
    
    // MARK: - Variables
    let rootUsersReference = Database.database().reference(withPath: FirebaseKnot.Users)
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
        title = "Cadastro"
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func didTapCreateAccountButon() {
        let createAccountManager = FirebaseAuthManager()
        if let firstName = self.firstNameTextField.text,
            let lastName = self.lastNameTextField.text,
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text {
            
            createAccountManager.createUser(email: email, password: password) { [weak self](userId) in
                
                guard let `self` = self else {
                    return
                }
                
                var message = ""
                var title = ""
                
                if let userId = userId {
                    
                    let userProfile = UserProfile(userId: userId, firstName: firstName, lastName: lastName, email: email, cellphone: "", phone: "", birthDate: "", accountType: .DefaultAccount, userImageURL: nil, userImageData: nil, professionalCards: [])
                    
                    FirebaseAuthManager().updateUser(user: userProfile) { (success) in
                        PreferencesManager.sharedInstance().saveUserProfile(user: userProfile)
                    }
                    
                    title = String.localize("commom_success_title_alert")
                    message = String.localize("registration_success_account_creation")
                } else {
                    title = String.localize("commom_warning_title_alert")
                    message = String.localize("common_error_message")
                }
                
                // Alert
                let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                    if let _ = userId {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }))
                
                self.navigationController?.present(alertViewController, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
