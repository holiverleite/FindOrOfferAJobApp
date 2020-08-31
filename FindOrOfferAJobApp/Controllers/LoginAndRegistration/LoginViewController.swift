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
            self.userLoginTextField.layer.borderWidth = 1.0
            self.userLoginTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField.placeholder = String.localize("registration_password")
            self.passwordTextField.layer.borderWidth = 1.0
            self.passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            self.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
            loginButton?.layer.cornerRadius = 4.0
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
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
        
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
                FirebaseAuthManager().retrieveUserFromFirebase(userId: userId) { (userProfile) in
                    if let userProfile = userProfile {
                        PreferencesManager.sharedInstance().saveUserProfile(user: userProfile)
                        self.navigationController?.popToRootViewController(animated: false)
                    }
                }
            } else {
                let alertViewController = UIAlertController(title: String.localize("commom_warning_title_alert"), message: String.localize("login_wrong_user_or_password"), preferredStyle: .alert)
                
                alertViewController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                    self.passwordTextField.text = ""
                }))
                
                self.navigationController?.present(alertViewController, animated: true, completion: nil)
            }
        }
    }
    
    private func downloadUserImageData(imageUrl: URL, completion: @escaping (_ image: Data?) -> Void) {
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let data = data {
                completion(data)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LoginViewController: NavigationDelegate {
    // Login Success with Google Account
    func signWithGoogleAccount(user: UserProfile, firstLogin: Bool) {
        
        if firstLogin {
            FirebaseAuthManager().updateUser(user: user) { (success) in
                PreferencesManager.sharedInstance().saveUserProfile(user: user)
                self.navigationController?.popToRootViewController(animated: false)
            }
        } else {
            PreferencesManager.sharedInstance().saveUserProfile(user: user)
            self.navigationController?.popToRootViewController(animated: false)
        }
        
        if let userImageURL = user.userImageURL, let url = URL(string: userImageURL), user.userImageData == nil {
            self.downloadUserImageData(imageUrl: url) { (data) in
                user.userImageData = data
                PreferencesManager.sharedInstance().saveUserProfile(user: user)
            }
        }
    }
}
