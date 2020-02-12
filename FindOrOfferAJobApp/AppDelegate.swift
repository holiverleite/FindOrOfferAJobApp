//
//  AppDelegate.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 25/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        // Override point for customization after application launch.
        return true
    }
}

