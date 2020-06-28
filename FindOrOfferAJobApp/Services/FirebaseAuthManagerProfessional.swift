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
    
    func retrieveCandidatesFromFirebase(userIds: [String], occupationAreaAnnounce: String, completion: @escaping (_ profile: [UserProfile]?) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        var candidates: [UserProfile] = []
        for id in userIds {
            dispatchGroup.enter()
            let ref = self.rootUsersReference.child(id)
            ref.observeSingleEvent(of: .value) { (dataSnapshot) in
                guard let data = dataSnapshot.value as? [String: Any],
                    let firstName = data[FirebaseUser.FirstName] as? String,
                    let lastName = data[FirebaseUser.LastName] as? String,
                    let birthDate = data[FirebaseUser.BirthDate] as? String,
                    let userImageURL = data[FirebaseUser.UserImageURL] as? String
                    else {
                        completion(nil)
                        return
                }
                
                var cards: [ProfessionalCard] = []
                if let data = dataSnapshot.value as? [String:Any], let professionalCards = data[FirebaseUser.ProfessionalCards] as? [String:Any] {
                    for cardItem in professionalCards {
                        if let card = cardItem.value as? [String: String], let occupationArea = card[FirebaseUser.OccupationArea], let experienceTime = card[FirebaseUser.ExperienceTime], let description = card[FirebaseUser.DescriptionOfProfession] {
                            
                            if occupationArea == occupationAreaAnnounce {
                                let professionalCard = ProfessionalCard(id: cardItem.key, occupationArea: occupationArea,
                                                                        experienceTime: experienceTime, descriptionOfProfession: description)
                                cards.append(professionalCard)
                            }
                        }
                    }
                }
                
                let userProfile = UserProfile(userId: id,
                                              firstName: firstName,
                                              lastName: lastName,
                                              email: "******@gmail.com",
                                              cellphone: "(**)*****-****",
                                              phone: "(**)*****-****",
                                              birthDate: birthDate,
                                              accountType: .GoogleAccount,
                                              userImageURL: userImageURL,
                                              userImageData: nil,
                                              professionalCards: cards)
                
                dispatchGroup.enter()
                if let url = URL(string: userImageURL) {
                    self.downloadUserImageData(imageUrl: url) { (data) in
                        if let data = data {
                            userProfile.userImageData = data
                        }
                        dispatchGroup.leave()
                    }
                }
                
                candidates.append(userProfile)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            completion(candidates)
        }) 
    }
}
