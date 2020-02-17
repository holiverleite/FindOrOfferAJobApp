//
//  PostLaunchScreenViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 13/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class PostLaunchScreenViewController: UIViewController {
    
    // MARK: - Routes
    enum StoryboardNavigate: String {
        case Main
        case Home
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

    @IBOutlet weak var activityIndicator: UIActivity!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil {
            let homeStoryboard = UIStoryboard(name: StoryboardNavigate.Home.rawValue, bundle: nil)
            if let homeViewController = homeStoryboard.instantiateInitialViewController() {
                self.present(homeViewController, animated: true, completion: nil)
            }
        } else {
            let mainStoryboard = UIStoryboard(name: StoryboardNavigate.Main.rawValue, bundle: nil)
            if let mainViewController = mainStoryboard.instantiateInitialViewController() {
                self.present(mainViewController, animated: true, completion: nil)
            }
        }
    }
}
