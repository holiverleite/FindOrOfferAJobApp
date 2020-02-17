//
//  HomeViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton! {
        didSet {
            self.logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if let userProfile = PreferencesManager.sharedInstance().retrieveCredencials() {
//            self.mainLabel.text = String(format: String.localize("home_welcome_message"), userProfile.firstName, userProfile.email)
//        }
    }
    
    @objc func didTapLogoutButton() {
        FirebaseAuthManager().signOut { [weak self](success) in
            if success {
                self?.navigationController?.dismiss(animated: false, completion: nil)
            } else {
                print("Error Logout")
            }
        }
//        PreferencesManager.sharedInstance().deleteUserCredential()
//        self.navigationController?.dismiss(animated: false, completion: nil)
    }
}
