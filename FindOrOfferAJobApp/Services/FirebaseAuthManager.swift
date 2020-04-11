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
    
    let rootUsersReference = Database.database().reference(withPath: FirebaseKnot.Users)

    //
    // USER
    //
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
            
            guard let data = dataSnapshot.value as? [String: String],
                let firstName = data[FirebaseUser.FirstName],
                let lastName = data[FirebaseUser.LastName],
                let email = data[FirebaseUser.Email],
                let cellPhone = data[FirebaseUser.Cellphone],
                let phone = data[FirebaseUser.Phone],
                let birthDate = data[FirebaseUser.BirthDate],
                let accountType = data[FirebaseUser.TypeAccount],
                let userImageURL = data[FirebaseUser.UserImageURL] else {
                    completion(nil)
                    return
            }
            
            let userProfile = UserProfile(userId: userId,
                                          firstName: firstName,
                                          lastName: lastName,
                                          email: email,
                                          cellphone: cellPhone,
                                          phone: phone,
                                          birthDate: birthDate,
                                          accountType: accountType == UserProfile.AccountType.DefaultAccount.rawValue ? UserProfile.AccountType.DefaultAccount : UserProfile.AccountType.GoogleAccount,
                                          userImageURL: userImageURL, userImageData: nil)
            
            completion(userProfile)
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
    
    //
    // PROFESSIONAL DATA
    //
    func addProfessionalCard(userId: String, professionalCard: ProfessionalCard, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = self.rootUsersReference.child(userId).child(FirebaseUser.ProfessionalCards).childByAutoId()
        let professionalCardDict: [String: Any] = [
            FirebaseUser.OccupationArea: professionalCard.occupationArea,
            FirebaseUser.ExperienceTime: professionalCard.experienceTime
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
