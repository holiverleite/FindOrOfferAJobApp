//
//  MainViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Routes
    enum StoryboardNavigate: String {
        case Login
        case Registration
    }

    // MARK: - IBOutlets
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            self.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signupButton: UIButton! {
        didSet {
            self.signupButton.addTarget(self, action: #selector(didTapSighUpButton), for: .touchUpInside)
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Selectors
    @objc func didTapLoginButton() {
        let loginStoryboard = UIStoryboard(name: StoryboardNavigate.Login.rawValue, bundle: nil)
        if let loginViewController = loginStoryboard.instantiateInitialViewController() {
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    @objc func didTapSighUpButton() {
        let registrationStoryboard = UIStoryboard(name: StoryboardNavigate.Registration.rawValue, bundle: nil)
        if let registrationViewController = registrationStoryboard.instantiateInitialViewController() {
            self.navigationController?.pushViewController(registrationViewController, animated: true)
        }
    }
}
