//
//  ProfileViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 19/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    enum ProfileItems: String, CaseIterable {
        case UserResumeCard
        case EditPersonalData = "Dados Pessoais"
        case EditProfessionalData = "Dados Profissionais"
        case Settings = "Configurações"
        case Logout = "Sair"
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.register(UserResumeTableViewCell.self, forCellReuseIdentifier: String(describing: UserResumeTableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: UserResumeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserResumeTableViewCell.self))
            
            self.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: String(describing: SettingsTableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: SettingsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SettingsTableViewCell.self))
            
            self.tableView.separatorStyle = .none
        }
    }
    
    // MARK: - Variables
    var userProfileViewModel = UserProfileViewModel()

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = String.localize("profile_nav_bar")
        
        self.userProfileViewModel = UserProfileViewModel()
    }
    
    // MARK: - Methods
    func logoutUser() {
        
        switch self.userProfileViewModel.accountType {
        case .DefaultAccount:
            FirebaseAuthManager().signOut { [weak self] (success) in
                if success {
                    PreferencesManager.sharedInstance().deleteUserProfile()
                    self?.navigationController?.popToRootViewController(animated: true)
                } else {
                    print("Error Logout")
                }
            }
        case .GoogleAccount:
            GIDSignIn.sharedInstance()?.signOut()
            
            PreferencesManager.sharedInstance().deleteUserProfile()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else {
            return 70
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userProfileViewModel.profileOptions.count
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsTableViewCell.self), for: indexPath) as? SettingsTableViewCell else {
                fatalError("SettingsTableViewCell not found!")
            }
            
            let settingsItem = self.userProfileViewModel.profileOptions[indexPath.row]
            
            switch settingsItem {
            case .UserResumeCard:
                break
            case .EditPersonalData:
                cell.nameLabel.text = ProfileViewController.ProfileItems.EditPersonalData.rawValue
                cell.imageView?.image = ImageConstants.Profile
            case .EditProfessionalData:
                cell.nameLabel.text = ProfileViewController.ProfileItems.EditProfessionalData.rawValue
                cell.imageView?.image = ImageConstants.Work
            case .Settings:
                cell.nameLabel.text = ProfileViewController.ProfileItems.Settings.rawValue
                cell.imageView?.image = ImageConstants.Settings
            case .Logout:
                cell.nameLabel.text = ProfileViewController.ProfileItems.Logout.rawValue
                cell.imageView?.image = ImageConstants.Logout
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let profileItem = self.userProfileViewModel.profileOptions[indexPath.row]
        
        switch profileItem {
        case .UserResumeCard:
            break
        case .EditPersonalData:
            self.performSegue(withIdentifier: "EditPersonalDataViewController", sender: nil)
        case .EditProfessionalData:
            self.performSegue(withIdentifier: "EditProfessionalDataViewController", sender: nil)
        case .Settings:
            self.performSegue(withIdentifier: "SettingsViewController", sender: nil)
        case .Logout:
            self.logoutUser()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingsViewController = segue.destination as? SettingsViewController {
            settingsViewController.userProfileViewModel = self.userProfileViewModel
        } else
        
        if let editPersonalDataViewController = segue.destination as? EditPersonalDataViewController {
            editPersonalDataViewController.userProfileViewModel = self.userProfileViewModel
        } else
        
        if let editProfessionalDataViewController = segue.destination as? EditProfessionalDataViewController {
            editProfessionalDataViewController.userProfileViewModel = self.userProfileViewModel
        }
    }
}
