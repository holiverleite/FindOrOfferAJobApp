//
//  EditProfileViewController.swift
//  
//
//  Created by Haroldo on 21/02/20.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView! {
        didSet {
            self.tableview.delegate = self
            self.tableview.dataSource = self
            
            self.tableview.register(UserResumeTableViewCell.self, forCellReuseIdentifier: String(describing: UserResumeTableViewCell.self))
            self.tableview.register(UINib(nibName: String(describing: UserResumeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserResumeTableViewCell.self))
            
            self.tableview.register(InputTableViewCell.self, forCellReuseIdentifier: String(describing: InputTableViewCell.self))
            self.tableview.register(UINib(nibName: String(describing: InputTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: InputTableViewCell.self))
            
            self.tableview.separatorStyle = .none
        }
    }
    
    // MARK: - Variables
    var userProfileViewModel = UserProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = String.localize("edit_profile_nav_bar")
        // Do any additional setup after loading the view.
    }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else {
            return 70
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserResumeTableViewCell.self), for: indexPath) as? UserResumeTableViewCell else {
                fatalError("UserResumeTableViewCell not found!")
            }
            
            if let dataImage = self.userProfileViewModel.userImageData {
                cell.userImageView.image = UIImage(data: dataImage)
            }
            
            cell.selectionStyle = .none
            
            return cell
            
        } else {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InputTableViewCell.self), for: indexPath) as? InputTableViewCell else {
                fatalError("InputTableViewCell not found!")
            }
            
//            let settingsItem = self.userProfileViewModel.profileOptions[indexPath.row]
            
            cell.inputDescription.text = "Nome"
            cell.inputTextField.text = self.userProfileViewModel.firstName
//            switch settingsItem {
//            case .UserResumeCard:
//                break
//            case .EditProfile:
//                cell.nameLabel.text = ProfileViewController.ProfileItems.EditProfile.rawValue
//                cell.imageView?.image = ImageConstants.Profile
//            case .Settings:
//                cell.nameLabel.text = ProfileViewController.ProfileItems.Settings.rawValue
//                cell.imageView?.image = ImageConstants.Settings
//            case .Logout:
//                cell.nameLabel.text = ProfileViewController.ProfileItems.Logout.rawValue
//                cell.imageView?.image = ImageConstants.Logout
//            }
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
}
