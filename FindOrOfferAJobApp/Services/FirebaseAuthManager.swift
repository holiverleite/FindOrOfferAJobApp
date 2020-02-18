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

    func createUser(email: String, password: String, completion: @escaping (_ userId: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                completion(user.uid)
            } else {
                completion(nil)
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (_ userId: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completion(nil)
            } else {
                completion(authResult?.user.uid)
            }
        }
    }
    
    func signOut(completion: @escaping (_ success:Bool) -> Void) {
        if let _ = try? Auth.auth().signOut() {
            completion(true)
        } else {
            completion(false)
        }
    }
    
}
