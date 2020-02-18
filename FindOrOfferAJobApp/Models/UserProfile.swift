//
//  UserProfile.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

class UserProfile: NSObject, NSCoding {
    
    enum User: String {
        case userId
        case firstName
        case lastName
        case email
    }
    
    let userId: String // Cant be changed
    var firstName: String
    var lastName: String
    let email: String // Cant be changed
    
    init(userId: String, firstName: String, lastName: String, email: String) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(userId, forKey: User.userId.rawValue)
        coder.encode(firstName, forKey: User.firstName.rawValue)
        coder.encode(lastName, forKey: User.lastName.rawValue)
        coder.encode(email, forKey: User.email.rawValue)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        if let userId = aDecoder.decodeObject(forKey: User.userId.rawValue) as? String,
            let firstName = aDecoder.decodeObject(forKey: User.firstName.rawValue) as? String,
            let lastName = aDecoder.decodeObject(forKey: User.lastName.rawValue) as? String,
            let email = aDecoder.decodeObject(forKey: User.email.rawValue) as? String {
            self.init(userId: userId, firstName: firstName, lastName: lastName, email: email)
        } else {
            self.init(userId: "", firstName: "", lastName: "", email: "")
        }
    }
}
