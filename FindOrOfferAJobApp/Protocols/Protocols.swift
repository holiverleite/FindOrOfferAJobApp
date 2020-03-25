//
//  Protocols.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 17/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

protocol NavigationDelegate: class {
    func signWithGoogleAccount(user: UserProfile, firstLogin: Bool)
}
