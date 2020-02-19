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
        case AccessScreen
        case MainFlow
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

    @IBOutlet weak var activityIndicator: UIActivity!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil || GIDSignIn.sharedInstance()?.currentUser != nil {
            let homeStoryboard = UIStoryboard(name: StoryboardNavigate.MainFlow.rawValue, bundle: nil)
            if let homeViewController = homeStoryboard.instantiateInitialViewController() {
                self.navigationController?.pushViewController(homeViewController, animated: true)
            }
        } else {
            let mainStoryboard = UIStoryboard(name: StoryboardNavigate.AccessScreen.rawValue, bundle: nil)
            if let mainViewController = mainStoryboard.instantiateInitialViewController() {
                self.navigationController?.pushViewController(mainViewController, animated: true)
            }
        }
    }
}
