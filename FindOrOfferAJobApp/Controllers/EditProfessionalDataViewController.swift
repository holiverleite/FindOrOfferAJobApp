//
//  EditProfessionalDataViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 31/03/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class EditProfessionalDataViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView! {
        didSet {
            self.tableview.delegate = self
            self.tableview.dataSource = self
            
//            self.tableview.register(InputTableViewCell.self, forCellReuseIdentifier: String(describing: InputTableViewCell.self))
//            self.tableview.register(UINib(nibName: String(describing: InputTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: InputTableViewCell.self))
            
            self.tableview.separatorStyle = .none
        }
    }
    
    // MARK: - Variables
    var userProfileViewModel = UserProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = String.localize("edit_professional_profile_nav_bar")
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
        // Do any additional setup after loading the view.
        let createButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(didTapCreateProfessionalCardButton))
        self.navigationItem.rightBarButtonItem = createButton
        
        self.tableview.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseAuthManager().retrieveProfessionalCards(userId: self.userProfileViewModel.userId) { (professionalCards) in
            print("")
            // show cards in the screen
        }
    }
    
    // MARK: - Methods
    @objc func didTapCreateProfessionalCardButton() {
        // did tap save
        self.performSegue(withIdentifier: "CreateProfessionalCardViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createProfessionalCard = segue.destination as? CreateProfessionalCardViewController {
            createProfessionalCard.userProfileViewModel = self.userProfileViewModel
        }
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditProfessionalDataViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        return UITableViewCell()
    }
}
