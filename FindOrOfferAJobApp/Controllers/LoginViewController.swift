//
//  LoginViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var userLoginTextField: UITextField! {
        didSet {
            self.userLoginTextField.placeholder = String.localize("registration_email")
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField.placeholder = String.localize("registration_password")
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            self.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var googleLoginButton: GIDSignInButton! {
        didSet {
            self.googleLoginButton.style = .wide
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.navigationDelegate = self
        }
    }
    
    // MARK: - Methods
    @objc func didTapLoginButton() {
        let loginManager = FirebaseAuthManager()
        guard let email = self.userLoginTextField.text, let password = self.passwordTextField.text else {
            return
        }
        
        loginManager.signIn(email: email, password: password) { [weak self](success) in
            guard let `self` = self else {
                return
            }
            
            if success {
//                let userProfile = UserProfile(firstName: "", lastName: "", email: email)
//                PreferencesManager.sharedInstance().saveUserCredentials(user: userProfile)
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                let alertViewController = UIAlertController(title: String.localize("commom_warning_title_alert"), message: String.localize("login_wrong_user_or_password"), preferredStyle: .alert)
                
                alertViewController.addAction(UIAlertAction(title: String.localize("login_ok_title"), style: .cancel, handler: { (_) in
                    self.passwordTextField.text = ""
                }))
                
                self.navigationController?.present(alertViewController, animated: true, completion: nil)
            }
        }
    }
}

extension LoginViewController: NavigationDelegate {
    func signWithGoogleAccount(user: UserProfile) {
//        PreferencesManager.sharedInstance().saveUserCredentials(user: user)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
