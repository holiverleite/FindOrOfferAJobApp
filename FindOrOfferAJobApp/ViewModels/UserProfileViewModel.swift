//
//  UserProfileViewModel.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 20/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

struct UserProfileViewModel {
    
    private let userProfile: UserProfile
    
    init() {
        if let userProfile = PreferencesManager.sharedInstance().retrieveUserProfile() {
            self.userProfile = userProfile
        } else {
            self.userProfile = UserProfile() // FIXME: - How to avoid this??
        }
    }
    
    var userId: String {
        return self.userProfile.userId
    }
    
    var firstName: String {
        return self.userProfile.firstName
    }
    
    var lastName: String {
        return self.userProfile.lastName
    }
    
    var email: String {
        return self.userProfile.email
    }
    
    var accountType: UserProfile.AccountType {
        return self.userProfile.accountType
    }
    
    var profileOptions: [ProfileViewController.ProfileItems] {
        return ProfileViewController.ProfileItems.allCases
    }
    
    var settingsOptions: [SettingsViewController.SettingItems] {
        switch self.userProfile.accountType {
        case .DefaultAccount:
            return [.ChangePassword, .DeleteAccount]
        case .GoogleAccount:
            return [.DeleteAccount]
        }
    }
}
