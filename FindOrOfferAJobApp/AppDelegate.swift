//
//  AppDelegate.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 25/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationDelegate: NavigationDelegate?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure Firebase
        FirebaseApp.configure()
        
        // Initialize sign-in
        GIDSignIn.sharedInstance()?.clientID = "226718689311-5hlq80rojgo7q5mbrvm0hhm081cqbekf.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        FirebaseAuthManager().retrieveUserFromFirebase(userId: user.userID) { (userProfile) in
            
            if let userProfile = userProfile {
                self.navigationDelegate?.signWithGoogleAccount(user: userProfile, firstLogin: false)
            } else {
                if let userId = user.userID,
                    let firstName = user.profile.name,
                    let lastName = user.profile.familyName,
                    let email = user.profile.email,
                    let userImageURL = user.profile.imageURL(withDimension: 120) {
                    
                    let userProfile = UserProfile(userId: userId,
                                                  firstName: firstName,
                                                  lastName: lastName,
                                                  email: email,
                                                  cellphone: "",
                                                  phone: "",
                                                  birthDate: "",
                                                  accountType: .GoogleAccount,
                                                  userImageURL: userImageURL.absoluteString,
                                                  userImageData: nil)
                    
                    self.navigationDelegate?.signWithGoogleAccount(user: userProfile, firstLogin: true)
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("")
    }
}

