//
//  LoginViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseDatabase

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
    
    // MARK: - Variables
    var rootUserReference = Database.database().reference(withPath: FirebaseKnot.Users)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.navigationDelegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Methods
    @objc func didTapLoginButton() {
        let loginManager = FirebaseAuthManager()
        guard let email = self.userLoginTextField.text, let password = self.passwordTextField.text else {
            return
        }
        
        loginManager.signIn(email: email, password: password) { [weak self] (userId) in
            guard let `self` = self else {
                return
            }
            // Login Success with Email and Passwd
            if let userId = userId {
                // FIXME: REcover the user from firebase after the login
                var _ = self.rootUserReference.child(userId).observeSingleEvent(of: .value) { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if let firstName = value?.object(forKey: FirebaseUser.FirstName) as? String,
                        let lastName = value?.object(forKey: FirebaseUser.LastName) as? String,
                        let email = value?.object(forKey: FirebaseUser.Email) as? String {
                        
                        let userProfile = UserProfile(userId: userId, firstName: firstName, lastName: lastName, email: email, accountType: .DefaultAccount)
                        // Save/Update User in Firebase
                        PreferencesManager.sharedInstance().saveUserProfile(user: userProfile)
                        self.navigationController?.popToRootViewController(animated: false)
                    }
                    
                }
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
    // Login Success with Google Account
    func signWithGoogleAccount(user: UserProfile) {
        
        let userDict : [String:Any] = [FirebaseUser.FirstName: user.firstName, FirebaseUser.LastName: user.lastName, FirebaseUser.Email: user.email]
        
        let ref = self.rootUserReference.child(user.userId)
        ref.setValue(userDict)
        
        // Save/Update User in Firebase
        PreferencesManager.sharedInstance().saveUserProfile(user: user)
        self.navigationController?.popToRootViewController(animated: false)
        
    }
}
