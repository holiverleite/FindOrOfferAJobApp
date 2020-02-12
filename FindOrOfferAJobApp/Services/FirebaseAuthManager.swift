//
//  FirebaseAuthManager.swift
//  FindOrOfferAJobApp
//
//  Created by HaroldoLeite on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager {
    
    func createUser(email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                print(user)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
