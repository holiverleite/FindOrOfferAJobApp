//
//  RecommendedJobsForYouViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 30/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class RecommendedJobsForYouViewController: UIViewController {

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)

        view.bringSubviewToFront(emptyView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = String.localize("job_for_you_nav_bar")
    }
    
    // MARK: - Private Methods
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
