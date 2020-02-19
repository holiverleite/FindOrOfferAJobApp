//
//  SettingsViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 19/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit
import GoogleSignIn

class SettingsViewController: UIViewController {
    
    enum SettingItems: String, CaseIterable {
        case Profile = "Perfil"
        case Logout = "Sair"
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: String(describing: SettingsTableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: SettingsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SettingsTableViewCell.self))
            
            self.tableView.separatorStyle = .none
            self.tableView.rowHeight = 50
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = String.localize("settings_nav_bar")
        
        if let userProfile = PreferencesManager.sharedInstance().retrieveUserProfile() {

        }
    }
    
    func logoutUser() {
        
        // SignOut from Google Login
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            GIDSignIn.sharedInstance()?.signOut()
            
            PreferencesManager.sharedInstance().deleteUserProfile()
            self.navigationController?.popToRootViewController(animated: true)
        }
        // SignOut from User/Password Login
        else {
            FirebaseAuthManager().signOut { [weak self] (success) in
                if success {
                    PreferencesManager.sharedInstance().deleteUserProfile()
                    self?.navigationController?.popToRootViewController(animated: true)
                } else {
                    print("Error Logout")
                }
            }
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingItems.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsTableViewCell.self), for: indexPath) as? SettingsTableViewCell else {
            fatalError("SettingsTableViewCell not found!")
        }
        
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.nameLabel.text = SettingItems.Profile.rawValue
            cell.imageView?.image = ImageConstants.Profie
        case 1:
            cell.nameLabel.text = SettingItems.Logout.rawValue
            cell.imageView?.image = ImageConstants.Logout
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            self.logoutUser()
        default:
            break
        }
    }
}
