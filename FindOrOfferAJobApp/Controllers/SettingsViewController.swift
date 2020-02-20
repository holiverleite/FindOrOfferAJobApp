//
//  ProfileViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 19/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit
import GoogleSignIn

class SettingsViewController: UIViewController {
    
    enum SettingItems: String, CaseIterable {
        case ChangePassword = "Alterar Senha"
        case DeleteAccount = "Deletar Conta"
    }
    
    // MARK: - IBOutlets
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
    
    // MARK: - Variables
    var userProfileViewModel: UserProfileViewModel? = nil

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: - Create a default BarButtonItem
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
        self.navigationItem.title = String.localize("settings_nav_bar")
    }
    
    // MARK: - Methods
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userProfileViewModel = self.userProfileViewModel else {
            return 0
        }
        
        return userProfileViewModel.settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsTableViewCell.self), for: indexPath) as? SettingsTableViewCell, let userProfileViewModel = self.userProfileViewModel else {
            fatalError("SettingsTableViewCell not found!")
        }
        
        let settingsItem = userProfileViewModel.settingsOptions[indexPath.row]
        
        switch settingsItem {
        case .ChangePassword:
            cell.nameLabel.text = SettingsViewController.SettingItems.ChangePassword.rawValue
            cell.imageView?.image = ImageConstants.Lock
        case .DeleteAccount:
            cell.nameLabel.text = SettingsViewController.SettingItems.DeleteAccount.rawValue
            cell.imageView?.image = ImageConstants.Delete
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let userProfileViewModel = self.userProfileViewModel else {
            return
        }
        
        let settingsItem = userProfileViewModel.settingsOptions[indexPath.row]
        
        switch settingsItem {
        case .ChangePassword:
            self.performSegue(withIdentifier: "ChangePasswordViewController", sender: nil)
        case .DeleteAccount:
            break
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let changePasswordViewController = segue.destination as? ChangePasswordViewController {
            changePasswordViewController.userProfileViewModel = self.userProfileViewModel
        }
    }
}
