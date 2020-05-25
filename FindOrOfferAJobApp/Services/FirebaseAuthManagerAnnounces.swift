//
//  FirebaseAuthManagerAnnounces.swift
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

    func addAnnounceJob(userId: String, announceJob: AnnounceJob, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = self.rootUsersReference.child(userId).child(FirebaseUser.AnnounceJob).childByAutoId()
        let professionalCardDict: [String: Any] = [
            FirebaseUser.OccupationArea: announceJob.occupationArea,
            FirebaseUser.DescriptionOfProfession: announceJob.descriptionOfAnnounce,
            FirebaseUser.StartDate: announceJob.startTimestamp,
            FirebaseUser.FinishDate: announceJob.finishTimestamp
        ]
        
        ref.setValue(professionalCardDict) { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func retrieveAnnouncesJob(userId: String, completion: @escaping (_ professionalCards: [AnnounceJob]) -> Void) {
        let ref = self.rootUsersReference.child(userId).child(FirebaseUser.AnnounceJob)
        ref.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let data = dataSnapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var announces: [AnnounceJob] = []
            for announceItem in data {
                if let item = announceItem.value as? [String: Any] {
                    if let occupationArea = item[FirebaseUser.OccupationArea] as? String, let startDate = item[FirebaseUser.StartDate] as? Double, let finishDate = item[FirebaseUser.FinishDate] as? Double, let description = item[FirebaseUser.DescriptionOfProfession] as? String {
                        let announce = AnnounceJob(id: announceItem.key, occupationArea: occupationArea, startTimestamp: startDate, finishTimestamp: finishDate, descriptionOfAnnounce: description)
                        announces.append(announce)
                    }
                }
            }
            completion(announces)
        }
    }
}
