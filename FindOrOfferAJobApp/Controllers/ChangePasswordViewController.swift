//
//  ChangePasswordViewController.swift
//  FindOrOfferAJobApp
//
//  Created by monitora on 20/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var newPasswordTextField: UITextField! {
        didSet {
            self.newPasswordTextField.placeholder = String.localize("new_password_placeholder")
        }
    }
    
    @IBOutlet weak var retypeNewPasswordTextField: UITextField! {
        didSet {
            self.retypeNewPasswordTextField.placeholder = String.localize("retype_new_password_placeholder")
        }
    }
    
    @IBOutlet weak var saveNewPasswordButton: UIButton! {
        didSet {
            self.saveNewPasswordButton.setTitle(String.localize("save_changes_button"), for: .normal)
            self.saveNewPasswordButton.addTarget(self, action: #selector(didTapSaveChanges), for: .touchUpInside)
        }
    }
    
    // MARK: - Variables
    var userProfileViewModel: UserProfileViewModel? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = String.localize("change_password_nav_bar")
    }
    
    // MARK: - Methods
    @objc func didTapSaveChanges() {
        if self.validateFields() {
            if let newPassword = self.newPasswordTextField.text {
                FirebaseAuthManager().changePassword(to: newPassword) { (success) in
                    if success {
                        print("Alert - Success changing PAssword")
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        print("Alert - Error changing PAssword")
                    }
                }
            }
        }
    }
    
    private func validateFields() -> Bool {
        if let newPassword = self.newPasswordTextField.text, let retypePassword = self.retypeNewPasswordTextField.text {
            if newPassword.isEmpty || retypePassword.isEmpty || (newPassword != retypePassword) {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
}
