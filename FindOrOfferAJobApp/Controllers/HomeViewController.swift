//
//  HomeViewController.swift
//  FindOrOfferAJobApp
//
//  Created by monitora on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userProfile = PreferencesManager.sharedInstance().retrieveCredencials() {
            self.mainLabel.text = String(format: String.localize("home_welcome_message"), userProfile.firstName)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
