//
//  PhoneNumberViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Oliveira de Almeida Leite on 08/08/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class PhoneNumberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumerTextField: UITextField! {
        didSet {
            phoneNumerTextField.delegate = self
            phoneNumerTextField.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var finishButton: UIButton! {
        didSet {
            finishButton.isEnabled = false
            finishButton.backgroundColor = .gray
            finishButton.addTarget(self, action: #selector(continueButtonDidTap), for: .touchUpInside)
        }
    }
    
    var user: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Contato"
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
    }
    
    @objc
    func continueButtonDidTap() {
        if let userProfile = user, let cellPhone = phoneNumerTextField.text {
            userProfile.cellphone = cellPhone
            FirebaseAuthManager().updateUser(user: userProfile) { (success) in
                PreferencesManager.sharedInstance().saveUserProfile(user: userProfile)
                let homeStoryboard = UIStoryboard(name: "MainFlow", bundle: nil)
                if let homeViewController = homeStoryboard.instantiateInitialViewController() {
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                }
            }
        }
    }
    
    // MARK: - Methods
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //New String and components
        let newStr = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let components = (newStr as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)

        //Decimal string, length and leading
        let decimalString = components.joined(separator: "") as NSString
        let length = decimalString.length
        let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)

        
        if length == 11 {
            finishButton.isEnabled = true
            finishButton.backgroundColor = .systemBlue
        } else {
            finishButton.isEnabled = false
            finishButton.backgroundColor = .gray
        }
        
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
}
