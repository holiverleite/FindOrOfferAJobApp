//
//  FirebaseAuthManager.swift
//  FindOrOfferAJobApp
//
//  Created by HaroldoLeite on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class FirebaseAuthManager {
    
    let usersReference = Database.database().reference(withPath: FirebaseKnot.Users)
    let globalAnnounceReference = Database.database().reference(withPath: FirebaseKnot.GlobalAnnounces)
    
    func downloadUserImageData(imageUrl: URL, completion: @escaping (_ image: Data?) -> Void) {
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let data = data {
                completion(data)
            } else {
                completion(nil)
            }
        }.resume()
    } 
}
