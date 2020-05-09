//
//  AnnounceOrOfferJobViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 09/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class AnnounceOrOfferJobViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            self.segmentedControl.addTarget(self, action: #selector(segmentedControlDidChanged), for: .valueChanged)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = String.localize("find_a_job_nav_bar")
        
        
    }
    
    @objc func segmentedControlDidChanged() {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.navigationController?.navigationBar.topItem?.title = String.localize("find_a_job_nav_bar")
        } else {
            self.navigationController?.navigationBar.topItem?.title = String.localize("announce_a_job_nav_bar")
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
