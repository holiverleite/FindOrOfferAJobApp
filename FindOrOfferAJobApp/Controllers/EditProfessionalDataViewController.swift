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
            
//            self.tableview.register(UserResumeTableViewCell.self, forCellReuseIdentifier: String(describing: UserResumeTableViewCell.self))
//            self.tableview.register(UINib(nibName: String(describing: UserResumeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserResumeTableViewCell.self))
            
            self.tableview.register(InputTableViewCell.self, forCellReuseIdentifier: String(describing: InputTableViewCell.self))
            self.tableview.register(UINib(nibName: String(describing: InputTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: InputTableViewCell.self))
            
            self.tableview.separatorStyle = .none
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = String.localize("edit_professional_profile_nav_bar")
        // Do any additional setup after loading the view.
        let saveButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(didTapCreateProfessionalCardButton))
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.tableview.isHidden = true
    }
    
    @objc func didTapCreateProfessionalCardButton() {
        // did tap save
    }
}

extension EditProfessionalDataViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 150
//        } else {
            return 70
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.row == 0 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserResumeTableViewCell.self), for: indexPath) as? UserResumeTableViewCell else {
//                fatalError("UserResumeTableViewCell not found!")
//            }
            
//            if let dataImage = self.userProfileViewModel?.userImageData {
//                cell.userImageView.image = UIImage(data: dataImage)
//            }
            
//            cell.selectionStyle = .none
//            
//            return cell
//            
//        } else {
//            return UITableViewCell()
//        }
    }
}
