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
//    case Telefone
//    case BirthDate
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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackground)))
        self.loadUserProfileValues()

        self.navigationItem.title = String.localize("edit_personal_profile_nav_bar")
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
        
        // Do any additional setup after loading the view.
        let saveButton = UIBarButtonItem(title: "Salvar", style: .plain, target: self, action: #selector(didTapSaveButton))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc
    func didTapBackground() {
        self.view.endEditing(true)
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
        
        self.userProfile = UserProfile(userId: userViewModel.userId, firstName: userViewModel.firstName, lastName: userViewModel.lastName, email: userViewModel.email, cellphone: userViewModel.cellphone, phone: userViewModel.phone, birthDate: userViewModel.birthDate, accountType: userViewModel.accountType, userImageURL: userViewModel.userImageURL, userImageData: userViewModel.userImageData, professionalCards: [])
    }
    
    // MARK: - Methods
    @objc func didTapSaveButton() {
        self.view.endEditing(true)
        FirebaseAuthManager().updateUser(user: self.userProfile) { (success) in
            PreferencesManager.sharedInstance().saveUserProfile(user: self.userProfile)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
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
            
            switch profileItem {
            case .Nome:
                cell.type = .Nome
                cell.inputTextField.text = self.userProfileViewModel?.firstName
                cell.inputTextField.tag = 1
                cell.delegate = self
            case .Sobrenome:
                cell.type = .Sobrenome
                cell.inputTextField.text = self.userProfileViewModel?.lastName
                cell.inputTextField.tag = 2
                cell.delegate = self
            case .Email:
                cell.type = .Email
                cell.inputTextField.text = self.userProfileViewModel?.email
                cell.inputTextField.isEnabled = false
                cell.inputTextField.tag = 3
            case .Celular:
                cell.type = .Celular
                cell.inputTextField.text = self.userProfileViewModel?.cellphone
                cell.inputTextField.tag = 4
                cell.inputTextField.keyboardType = .numberPad
                cell.inputTextField.delegate = self
//            case .Telefone:
//                cell.type = .Telefone
//                cell.inputTextField.text = self.userProfileViewModel?.phone
//                cell.inputTextField.tag = 5
//            case .BirthDate:
//                cell.type = .BirthDate
//                cell.inputTextField.text = self.userProfileViewModel?.birthDate
//                cell.inputTextField.tag = 6
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

extension EditPersonalDataViewController: CustomTextFieldDelegate, UITextFieldDelegate {
    func textFieldDidChanged(_ textField: UITextField, type: ProfileOptions) {
        let inputText = textField.text
        switch type {
        case .Nome:
            inputText == self.userProfileViewModel?.firstName ? self.enableSaveButton(false) : self.enableSaveButton(true)
        case .Sobrenome:
            inputText == self.userProfileViewModel?.lastName ? self.enableSaveButton(false) : self.enableSaveButton(true)
        case .Celular:
            if inputText?.count == 12 {
                inputText == self.userProfileViewModel?.cellphone ? self.enableSaveButton(false) : self.enableSaveButton(true)
            } else {
                self.enableSaveButton(false)
            }
//        case .Telefone:
//            inputText == self.userProfileViewModel?.phone ? self.enableSaveButton(false) : self.enableSaveButton(true)
//        case .BirthDate:
//            inputText == self.userProfileViewModel?.birthDate ? self.enableSaveButton(false) : self.enableSaveButton(true)
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
//        case .Telefone:
//            self.userProfile.phone = inputText
//        case .BirthDate:
//            self.userProfile.birthDate = inputText
        case .Email:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var point = textField.frame.origin
        point.x = 10
        
        switch textField.tag {
        case 4:   
            point.y = (point.y - 5) * CGFloat(textField.tag)
        case 5:
            point.y = (point.y - 5) * CGFloat(textField.tag)
        case 6:
            point.y = (point.y + 5) * CGFloat(textField.tag)
        default:
            return
        }
        
        tableview.setContentOffset(point, animated: true)
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableview.setContentOffset(.zero, animated: true)
        self.view.endEditing(true)
        
        self.textFieldDidEndEditing(textField, type: .Celular)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //New String and components
        if textField.tag == 4 {
            self.textFieldDidChanged(textField, type: .Celular)
            let newStr = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = (newStr as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)

            //Decimal string, length and leading
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            //Checking the length
            if length == 0 || (length > 11 && !hasLeadingOne) || length > 13 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int

                return (newLength > 11) ? false : true
            }

            //Index and formatted string
            var index = 0 as Int
            let formattedString = NSMutableString()

            //Check if it has leading
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }

            //Area Code
            if (length - index) > 2 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 2))
                formattedString.appendFormat("%@ ", areaCode)
                index += 2
            }

            if length - index > 5 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 5))
                formattedString.appendFormat("%@-", prefix)
                index += 5
            }

            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            
            return false
        }
        
        return true
    }
}
