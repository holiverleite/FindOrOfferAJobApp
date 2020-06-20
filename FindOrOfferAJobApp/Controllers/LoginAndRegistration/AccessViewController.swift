//
//  AccessViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class AccessViewController: UIViewController {
    
    // MARK: - Routes
    enum StoryboardNavigate: String {
        case Login
        case Registration
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton?.layer.borderWidth = 1.0
            loginButton?.layer.borderColor = UIColor.systemBlue.cgColor
            loginButton?.layer.cornerRadius = 4.0
        }
    }
    
    @IBOutlet weak var signupButton: UIButton! {
        didSet {
            signupButton?.layer.cornerRadius = 4.0
        }
    }
}
