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
        case firstName
        case lastName
        case email
    }
    
    var firstName: String
    var lastName: String
    var email: String
    
    init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(firstName, forKey: User.firstName.rawValue)
        coder.encode(lastName, forKey: User.lastName.rawValue)
        coder.encode(email, forKey: User.email.rawValue)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        if let firstName = aDecoder.decodeObject(forKey: User.firstName.rawValue) as? String,
            let lastName = aDecoder.decodeObject(forKey: User.lastName.rawValue) as? String,
            let email = aDecoder.decodeObject(forKey: User.email.rawValue) as? String {
            self.init(firstName: firstName, lastName: lastName, email: email)
        } else {
            self.init(firstName: "", lastName: "", email: "")
        }
    }
}
