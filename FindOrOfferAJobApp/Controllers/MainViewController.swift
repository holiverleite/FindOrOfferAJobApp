//
//  MainViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    // MARK: - Routes
    enum StoryboardNavigate: String {
        case Login
        case Registration
    }

    // MARK: - IBOutlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
}
