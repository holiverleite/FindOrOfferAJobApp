//
//  EditPersonalDataViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 21/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

enum ProfileOptions: String, CaseIterable {
    case Nome
    case Sobrenome
    case Email
    case Celular
    case Telefone
    case BirthDate
}

class EditPersonalDataViewController: UIViewController {
    
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
    var userProfileViewModel: UserProfileViewModel? = nil
    var userProfile: UserProfile = UserProfile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadUserProfileValues()

        self.navigationItem.title = String.localize("edit_personal_profile_nav_bar")
        // Do any additional setup after loading the view.
        let saveButton = UIBarButtonItem(title: "Salvar", style: .plain, target: self, action: #selector(didTapSaveButton))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userProfileViewModel = UserProfileViewModel()
    }
    
    func enableSaveButton(_ value: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = value
    }
    
    private func loadUserProfileValues() {
        guard let userViewModel = self.userProfileViewModel else {
            return
        }
        
        self.userProfile = UserProfile(userId: userViewModel.userId, firstName: userViewModel.firstName, lastName: userViewModel.lastName, email: userViewModel.email, cellphone: userViewModel.cellphone, phone: userViewModel.phone, birthDate: userViewModel.birthDate, accountType: userViewModel.accountType, userImageURL: userViewModel.userImageURL, userImageData: userViewModel.userImageData)
    }
    
    @objc func didTapSaveButton() {
        self.view.endEditing(true)
        FirebaseAuthManager().updateUser(user: self.userProfile) { (success) in
            PreferencesManager.sharedInstance().saveUserProfile(user: self.userProfile)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension EditPersonalDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileOptions.allCases.count + 1 // Adding the image row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserResumeTableViewCell.self), for: indexPath) as? UserResumeTableViewCell else {
                fatalError("UserResumeTableViewCell not found!")
            }
            
            if let dataImage = self.userProfileViewModel?.userImageData {
                cell.userImageView.image = UIImage(data: dataImage)
            }
            
            cell.selectionStyle = .none
            
            return cell
            
        } else {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InputTableViewCell.self), for: indexPath) as? InputTableViewCell else {
                fatalError("InputTableViewCell not found!")
            }
            
            let profileItem = ProfileOptions.allCases[indexPath.row - 1]
            
            cell.inputDescription.text = profileItem.rawValue
            cell.delegate = self
            
            switch profileItem {
            case .Nome:
                cell.type = .Nome
                cell.inputTextField.text = self.userProfileViewModel?.firstName
            case .Sobrenome:
                cell.type = .Sobrenome
                cell.inputTextField.text = self.userProfileViewModel?.lastName
            case .Email:
                cell.type = .Email
                cell.inputTextField.text = self.userProfileViewModel?.email
                cell.inputTextField.isEnabled = false
            case .Celular:
                cell.type = .Celular
                cell.inputTextField.text = self.userProfileViewModel?.cellphone
            case .Telefone:
                cell.type = .Telefone
                cell.inputTextField.text = self.userProfileViewModel?.phone
            case .BirthDate:
                cell.type = .BirthDate
                cell.inputTextField.text = self.userProfileViewModel?.birthDate
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

extension EditPersonalDataViewController: CustomTextFieldDelegate {
    func textFieldDidChanged(_ textField: UITextField, type: ProfileOptions) {
        let inputText = textField.text
        switch type {
        case .Nome:
            inputText == self.userProfileViewModel?.firstName ? self.enableSaveButton(false) : self.enableSaveButton(true)
        case .Sobrenome:
            inputText == self.userProfileViewModel?.lastName ? self.enableSaveButton(false) : self.enableSaveButton(true)
        case .Celular:
            inputText == self.userProfileViewModel?.cellphone ? self.enableSaveButton(false) : self.enableSaveButton(true)
        case .Telefone:
            inputText == self.userProfileViewModel?.phone ? self.enableSaveButton(false) : self.enableSaveButton(true)
        case .BirthDate:
            inputText == self.userProfileViewModel?.birthDate ? self.enableSaveButton(false) : self.enableSaveButton(true)
        case .Email:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, type: ProfileOptions) {
        
        guard let inputText = textField.text else {
            return
        }
        
        switch type {
        case .Nome:
            self.userProfile.firstName = inputText
        case .Sobrenome:
            self.userProfile.lastName = inputText
        case .Celular:
            self.userProfile.cellphone = inputText
        case .Telefone:
            self.userProfile.phone = inputText
        case .BirthDate:
            self.userProfile.birthDate = inputText
        case .Email:
            break
        }
    }
}
