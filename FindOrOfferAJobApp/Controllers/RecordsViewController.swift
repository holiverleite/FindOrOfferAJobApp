//
//  RecordsViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 09/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class RecordsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = String.localize("records_nav_bar")
    }
}
