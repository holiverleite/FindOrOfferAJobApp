//
//  PreferencesManager.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

class PreferencesManager {
    
    // UserDefault Options
    enum Manager : String {
        case UserCredential
    }
    
    private static let instance = PreferencesManager()
    
    // MARK: - Singleton
    public static func sharedInstance() -> PreferencesManager {
        return instance
    }
    
    private func getUserDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    public func saveUserProfile(user: UserProfile) {
        let encodedUserProfileData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
        self.getUserDefaults().set(encodedUserProfileData, forKey: Manager.UserCredential.rawValue)
    }
    
    public func retrieveUserProfile() -> UserProfile? {
        if let decodedUserProfileData = self.getUserDefaults().object(forKey: Manager.UserCredential.rawValue) as? Data {
            if let userProfile = NSKeyedUnarchiver.unarchiveObject(with: decodedUserProfileData) as? UserProfile {
                return userProfile
            }
        }
        return nil
    }
    
    public func deleteUserProfile() {
        self.getUserDefaults().set(nil, forKey: Manager.UserCredential.rawValue)
    }
}
