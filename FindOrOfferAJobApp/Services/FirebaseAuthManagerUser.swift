//
//  FirebaseAuthManagerUser.swift
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

    func createUser(email: String, password: String, completion: @escaping (_ userId: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                completion(user.uid)
            } else {
                completion(nil)
            }
        }
    }
    
    func retrieveUserFromFirebase(userId: String, completion: @escaping (_ profile: UserProfile?) -> Void) {
        let ref = self.rootUsersReference.child(userId)
        ref.observeSingleEvent(of: .value) { (dataSnapshot) in
            
            
            guard let data = dataSnapshot.value as? [String: Any],
                let firstName = data[FirebaseUser.FirstName] as? String,
                let lastName = data[FirebaseUser.LastName] as? String,
                let email = data[FirebaseUser.Email] as? String,
                let cellPhone = data[FirebaseUser.Cellphone] as? String,
                let phone = data[FirebaseUser.Phone] as? String,
                let birthDate = data[FirebaseUser.BirthDate] as? String,
                let accountType = data[FirebaseUser.TypeAccount] as? String,
                let userImageURL = data[FirebaseUser.UserImageURL] as? String
            else {
                    completion(nil)
                    return
            }
            
            var cards: [ProfessionalCard] = []
            if let data = dataSnapshot.value as? [String:Any], let professionalCards = data[FirebaseUser.ProfessionalCards] as? [String:Any] {
                for cardItem in professionalCards {
                    if let card = cardItem.value as? [String: String], let occupationArea = card[FirebaseUser.OccupationArea], let experienceTime = card[FirebaseUser.ExperienceTime], let description = card[FirebaseUser.DescriptionOfProfession] {
                        let professionalCard = ProfessionalCard(id: cardItem.key, occupationArea: occupationArea,
                                                                experienceTime: experienceTime, descriptionOfProfession: description)
                        cards.append(professionalCard)
                    }
                }
            }
            
            
            let userProfile = UserProfile(userId: userId,
                                          firstName: firstName,
                                          lastName: lastName,
                                          email: email,
                                          cellphone: cellPhone,
                                          phone: phone,
                                          birthDate: birthDate,
                                          accountType: accountType == UserProfile.AccountType.DefaultAccount.rawValue ? UserProfile.AccountType.DefaultAccount : UserProfile.AccountType.GoogleAccount,
                                          userImageURL: userImageURL,
                                          userImageData: nil,
                                          professionalCards: cards)
            
            completion(userProfile)
        }
    }
    
    func retrieveProfessionalCards(userId: String, completion: @escaping (_ professionalCards: [ProfessionalCard]) -> Void) {
        let ref = self.rootUsersReference.child(userId).child(FirebaseUser.ProfessionalCards)
        ref.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let data = dataSnapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var cards: [ProfessionalCard] = []
            for cardItem in data {
                if let item = cardItem.value as? [String: Any] {
                    if let occupationArea = item[FirebaseUser.OccupationArea] as? String, let experienceTime = item[FirebaseUser.ExperienceTime] as? String, let description = item[FirebaseUser.DescriptionOfProfession] as? String {
                        let professionalCard = ProfessionalCard(id: cardItem.key, occupationArea: occupationArea, experienceTime: experienceTime, descriptionOfProfession: description)
                        cards.append(professionalCard)
                    }
                }
            }
            completion(cards)
        }
    }
    
    func updateUser(user: UserProfile, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = self.rootUsersReference.child(user.userId)
        let userDict: [String: Any] = [
            FirebaseUser.FirstName: user.firstName,
            FirebaseUser.LastName: user.lastName,
            FirebaseUser.Email: user.email,
            FirebaseUser.TypeAccount: user.accountType.rawValue,
            FirebaseUser.UserImageURL: user.userImageURL ?? "",
            FirebaseUser.Cellphone: user.cellphone,
            FirebaseUser.Phone: user.phone,
            FirebaseUser.BirthDate: user.birthDate
        ]
        
        ref.updateChildValues(userDict) { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
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
    
    func changePassword(to newPassword: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
            if let _ = error {
                completion(false)
            } else {
                completion(true)
            }
        })
    }
    
    func deleteProfile(profile: UserProfileViewModel, completion: @escaping (_ success: Bool) -> Void) {
        switch profile.accountType {
        case .DefaultAccount:
            
            self.rootUsersReference.child(profile.userId).removeValue(completionBlock: { (error, databaseReference) in
                Auth.auth().currentUser?.delete(completion: { (error) in
                    if let _ = error {
                        completion(false)
                    } else {
                        completion(true)
                    }
                })
            })
            
        case .GoogleAccount:
            GIDSignIn.sharedInstance()?.signOut()
            
            self.rootUsersReference.child(profile.userId).removeValue { (error, _) in
                if let _ = error {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
}
