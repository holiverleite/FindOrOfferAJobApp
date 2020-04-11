//
//  UserProfile.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

class UserProfile: NSObject, NSCoding {
    
    enum AccountType: String {
        case GoogleAccount
        case DefaultAccount
    }
    
    enum User: String {
        case userId
        case firstName
        case lastName
        case email
        case cellphone
        case phone
        case birthDate
        case accountType
        case userImageURL
        case userImageData
    }
    
    let userId: String // Cant be changed
    var firstName: String
    var lastName: String
    let email: String // Cant be changed
    var cellphone: String
    var phone: String
    var birthDate: String
    var accountType: AccountType
    var userImageURL: String?
    var userImageData: Data?
    
    override init() {
        self.userId = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.cellphone = ""
        self.phone = ""
        self.birthDate = ""
        self.accountType = .DefaultAccount
        self.userImageURL = nil
        self.userImageData = nil
    }
    
    init(userId: String,
         firstName: String,
         lastName: String,
         email: String,
         cellphone: String,
         phone: String,
         birthDate: String,
         accountType: AccountType,
         userImageURL: String?,
         userImageData: Data?) {
        
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.cellphone = cellphone
        self.phone = phone
        self.birthDate = birthDate
        self.accountType = accountType
        self.userImageURL = userImageURL
        self.userImageData = userImageData
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.userId, forKey: User.userId.rawValue)
        coder.encode(self.firstName, forKey: User.firstName.rawValue)
        coder.encode(self.lastName, forKey: User.lastName.rawValue)
        coder.encode(self.email, forKey: User.email.rawValue)
        coder.encode(self.cellphone, forKey: User.cellphone.rawValue)
        coder.encode(self.phone, forKey: User.phone.rawValue)
        coder.encode(self.birthDate, forKey: User.birthDate.rawValue)
        coder.encode(self.accountType.rawValue, forKey: User.accountType.rawValue)
        coder.encode(self.userImageURL, forKey: User.userImageURL.rawValue)
        coder.encode(self.userImageData, forKey: User.userImageData.rawValue)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        if let userId = aDecoder.decodeObject(forKey: User.userId.rawValue) as? String,
            let firstName = aDecoder.decodeObject(forKey: User.firstName.rawValue) as? String,
            let lastName = aDecoder.decodeObject(forKey: User.lastName.rawValue) as? String,
            let email = aDecoder.decodeObject(forKey: User.email.rawValue) as? String,
            let cellphone = aDecoder.decodeObject(forKey: User.cellphone.rawValue) as? String,
            let phone = aDecoder.decodeObject(forKey: User.phone.rawValue) as? String,
            let birthDate = aDecoder.decodeObject(forKey: User.birthDate.rawValue) as? String,
            let accountTypeDecoder = aDecoder.decodeObject(forKey: User.accountType.rawValue) as? String,
            let accountType: AccountType = UserProfile.AccountType(rawValue: accountTypeDecoder) {
            
            if let imageURL = aDecoder.decodeObject(forKey: User.userImageURL.rawValue) as? String, let imageData = aDecoder.decodeObject(forKey: User.userImageData.rawValue) as? Data {
                self.init(userId: userId, firstName: firstName, lastName: lastName, email: email, cellphone: cellphone, phone: phone, birthDate: birthDate, accountType: accountType, userImageURL: imageURL, userImageData: imageData)
            } else {
                self.init(userId: userId, firstName: firstName, lastName: lastName, email: email, cellphone: cellphone, phone: phone, birthDate: birthDate, accountType: accountType, userImageURL: nil, userImageData: nil)
            }
        } else {
            self.init(userId: "", firstName: "", lastName: "", email: "", cellphone: "", phone: "", birthDate: "", accountType: .DefaultAccount, userImageURL: nil, userImageData: nil)
        }
    }
}
