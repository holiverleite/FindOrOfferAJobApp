//
//  HomeViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit
import GoogleSignIn

class HomeViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton! {
        didSet {
            self.logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        if let userProfile = PreferencesManager.sharedInstance().retrieveUserProfile() {
            self.mainLabel.text = String(format: String.localize("home_welcome_message"), userProfile.firstName, userProfile.email)
        }
    }
    
    @objc func didTapLogoutButton() {
        
        // SignOut from Google Login
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            GIDSignIn.sharedInstance()?.signOut()
            
            PreferencesManager.sharedInstance().deleteUserProfile()
            self.navigationController?.popToRootViewController(animated: true)
        }
        // SignOut from User/Password Login
        else {
            FirebaseAuthManager().signOut { [weak self] (success) in
                if success {
                    PreferencesManager.sharedInstance().deleteUserProfile()
                    self?.navigationController?.popToRootViewController(animated: true)
                } else {
                    print("Error Logout")
                }
            }
        }
    }
}
