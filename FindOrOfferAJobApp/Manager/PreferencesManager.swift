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
    
    public func saveUserCredentials(user: UserProfile) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
        self.getUserDefaults().set(encodedData, forKey: Manager.UserCredential.rawValue)
    }
    
    public func retrieveCredencials() -> UserProfile? {
        if let decodedData = self.getUserDefaults().object(forKey: Manager.UserCredential.rawValue) as? Data {
            if let userProfile = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? UserProfile {
                return userProfile
            }
        }
        return nil
    }
}
