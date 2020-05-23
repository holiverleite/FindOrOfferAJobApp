//
//  FirebaseAuthManagerProfessional.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 23/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

extension FirebaseAuthManager {

    func addProfessionalCard(userId: String, professionalCard: ProfessionalCard, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = self.rootUsersReference.child(userId).child(FirebaseUser.ProfessionalCards).childByAutoId()
        let professionalCardDict: [String: Any] = [
            FirebaseUser.OccupationArea: professionalCard.occupationArea,
            FirebaseUser.ExperienceTime: professionalCard.experienceTime,
            FirebaseUser.DescriptionOfProfession: professionalCard.descriptionOfProfession
        ]
        
        ref.setValue(professionalCardDict) { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func deleteProfessionalCard(userId: String, cardId: String, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = self.rootUsersReference.child(userId).child(FirebaseUser.ProfessionalCards).child(cardId)
        ref.removeValue { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func updateProfessionalCard(userId: String, card: ProfessionalCard, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = self.rootUsersReference.child(userId).child(FirebaseUser.ProfessionalCards).child(card.id)
        let professionalCardDict: [String: Any] = [
            FirebaseUser.OccupationArea: card.occupationArea,
            FirebaseUser.ExperienceTime: card.experienceTime,
            FirebaseUser.DescriptionOfProfession: card.descriptionOfProfession
        ]
        ref.updateChildValues(professionalCardDict) { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
