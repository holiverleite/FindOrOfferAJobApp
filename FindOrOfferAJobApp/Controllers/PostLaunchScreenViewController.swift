//
//  PostLaunchScreenViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 13/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class PostLaunchScreenViewController: UIViewController {
    
    // MARK: - Routes
    enum StoryboardNavigate: String {
        case Main
        case Home
    }

    @IBOutlet weak var activityIndicator: UIActivity!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentUser = PreferencesManager.sharedInstance().retrieveCredencials()
        if currentUser != nil {
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
