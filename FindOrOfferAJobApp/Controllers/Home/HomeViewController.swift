//
//  HomeViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mySelectiveProcessButtonView: UIView! {
        didSet {
            self.mySelectiveProcessButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mySelectiveProcessButtonDidTap)))
        }
    }
    
    @IBOutlet weak var myAnnouncesButtonView: UIView! {
        didSet {
            self.myAnnouncesButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myAnnouncesButtonDidTap)))
        }
    }
    
    @IBOutlet weak var myProfessionalCards: UIView! {
        didSet {
            self.myProfessionalCards.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myProfessionalCardsDidTap)))
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = String.localize("home_nav_bar")
    }
    
    // MARK: - Private
    
    @objc
    private func mySelectiveProcessButtonDidTap() {
        self.performSegue(withIdentifier: "MyProccessViewController", sender: nil)
    }
    
    @objc
    private func myAnnouncesButtonDidTap() {
        self.performSegue(withIdentifier: "MyAnnouncesListViewController", sender: nil)
    }
    
    @objc
    private func myProfessionalCardsDidTap() {
        self.performSegue(withIdentifier: "EditProfessionalDataViewController", sender: nil)
    }
}
