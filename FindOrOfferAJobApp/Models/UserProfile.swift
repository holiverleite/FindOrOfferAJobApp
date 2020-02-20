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
        case accountType
    }
    
    let userId: String // Cant be changed
    var firstName: String
    var lastName: String
    let email: String // Cant be changed
    var accountType: AccountType
    
    override init() {
        self.userId = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.accountType = .DefaultAccount
    }
    
    init(userId: String, firstName: String, lastName: String, email: String, accountType: AccountType) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.accountType = accountType
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.userId, forKey: User.userId.rawValue)
        coder.encode(self.firstName, forKey: User.firstName.rawValue)
        coder.encode(self.lastName, forKey: User.lastName.rawValue)
        coder.encode(self.email, forKey: User.email.rawValue)
        coder.encode(self.accountType.rawValue, forKey: User.accountType.rawValue)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        if let userId = aDecoder.decodeObject(forKey: User.userId.rawValue) as? String,
            let firstName = aDecoder.decodeObject(forKey: User.firstName.rawValue) as? String,
            let lastName = aDecoder.decodeObject(forKey: User.lastName.rawValue) as? String,
            let email = aDecoder.decodeObject(forKey: User.email.rawValue) as? String,
            let accountTypeDecoder = aDecoder.decodeObject(forKey: User.accountType.rawValue) as? String,
            let accountType: AccountType = UserProfile.AccountType(rawValue: accountTypeDecoder) {
            self.init(userId: userId, firstName: firstName, lastName: lastName, email: email, accountType: accountType)
        } else {
            self.init(userId: "", firstName: "", lastName: "", email: "", accountType: .DefaultAccount)
        }
    }
}
