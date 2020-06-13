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
        func addAnnounceJobGlobalBank(announceId: String, announceJob: AnnounceJob, completion: @escaping (_ success: Bool) -> Void) {
            let ref = rootUsersReference.child(FirebaseUser.GlobalAnnounces).child(announceId)
            let announceDict: [String: Any] = [
                FirebaseUser.OccupationArea: announceJob.occupationArea,
                FirebaseUser.DescriptionOfProfession: announceJob.descriptionOfAnnounce,
                FirebaseUser.StartDate: announceJob.startTimestamp,
                FirebaseUser.FinishDate: announceJob.finishTimestamp,
                FirebaseUser.IsCanceledAnnounce: announceJob.isCanceled,
                FirebaseUser.Candidates: [:]
            ]
            
            ref.setValue(announceDict) { (error, databaseReference) in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
        
        let ref = self.rootUsersReference.child(userId).child(FirebaseUser.AnnounceJob).childByAutoId()
        let announceDict: [String: Any] = [
            FirebaseUser.OccupationArea: announceJob.occupationArea,
            FirebaseUser.DescriptionOfProfession: announceJob.descriptionOfAnnounce,
            FirebaseUser.StartDate: announceJob.startTimestamp,
            FirebaseUser.FinishDate: announceJob.finishTimestamp,
            FirebaseUser.IsCanceledAnnounce: announceJob.isCanceled,
            FirebaseUser.Candidates: [:]
        ]
        
        ref.setValue(announceDict) { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                if let announceId = databaseReference.key {
                    addAnnounceJobGlobalBank(announceId: announceId, announceJob: announceJob) { success in
                        if success {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                }
            }
        }
    }
    
    func cancelAnnounceJob(userId: String, announceJob: AnnounceJob, completion: @escaping (_ success: Bool?) -> Void) {
        
        func removeAnnounceJobGlobalBank(announceId: String, completion: @escaping (_ success: Bool) -> Void) {
            let ref = rootUsersReference.child(FirebaseUser.GlobalAnnounces).child(announceId)
            
            ref.removeValue { (error, databaseReference) in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
        
        let ref = self.rootUsersReference.child(userId).child(FirebaseUser.AnnounceJob).child(announceJob.id)
        let announceDict: [String: Any] = [
            FirebaseUser.OccupationArea: announceJob.occupationArea,
            FirebaseUser.DescriptionOfProfession: announceJob.descriptionOfAnnounce,
            FirebaseUser.StartDate: announceJob.startTimestamp,
            FirebaseUser.FinishDate: announceJob.finishTimestamp,
            FirebaseUser.IsCanceledAnnounce: true,
            FirebaseUser.Candidates: [:]
        ]
        
        // REmover anúncio da lista global
        
        ref.updateChildValues(announceDict) { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                if let announceId = databaseReference.key {
                    removeAnnounceJobGlobalBank(announceId: announceId) { (success) in
                        if success {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                }
            }
        }
    }
    
    
    func reactivateAnnounceJob(userId: String, announceJob: AnnounceJob, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = self.rootUsersReference.child(userId).child(FirebaseUser.AnnounceJob).child(announceJob.id)
        let announceDict: [String: Any] = [
            FirebaseUser.OccupationArea: announceJob.occupationArea,
            FirebaseUser.DescriptionOfProfession: announceJob.descriptionOfAnnounce,
            FirebaseUser.StartDate: announceJob.startTimestamp,
            FirebaseUser.FinishDate: announceJob.finishTimestamp,
            FirebaseUser.IsCanceledAnnounce: false,
            FirebaseUser.Candidates: [:]
        ]
        
        ref.updateChildValues(announceDict) { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func retrieveGlobalAnnouncesJob(completion: @escaping (_ announces: [AnnounceJob]) -> Void) {
        let ref = self.rootUsersReference.child(FirebaseUser.GlobalAnnounces)
        ref.observe(.value) { (dataSnapshot) in
            guard let data = dataSnapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var announces: [AnnounceJob] = []
            
            for announceItem in data {
                if let item = announceItem.value as? [String: Any] {
                    
                    if let occupationArea = item[FirebaseUser.OccupationArea] as? String, let startDate = item[FirebaseUser.StartDate] as? Double, let finishDate = item[FirebaseUser.FinishDate] as? Double, let description = item[FirebaseUser.DescriptionOfProfession] as? String, let isCancelledAnnounce = item[FirebaseUser.IsCanceledAnnounce] as? Bool {
                        
                        let announce = AnnounceJob(id: announceItem.key,
                                                   occupationArea: occupationArea,
                                                   startTimestamp: startDate,
                                                   finishTimestamp: finishDate,
                                                   isCanceled: isCancelledAnnounce,
                                                   candidatesIds: [],
                                                   descriptionOfAnnounce: description)
                        
                        announces.append(announce)
                    }
                }
            }
            completion(announces)
        }
    }

    func observeChanges() {
        
    }
    
    func retrieveAnnouncesJob(userId: String, onlyCancelledsAndFinisheds: Bool = false, completion: @escaping (_ professionalCards: [AnnounceJob]) -> Void) {
        let ref = self.rootUsersReference.child(userId).child(FirebaseUser.AnnounceJob)
        ref.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let data = dataSnapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var announces: [AnnounceJob] = []
            
            for announceItem in data {
                if let item = announceItem.value as? [String: Any] {
                    
                    if let occupationArea = item[FirebaseUser.OccupationArea] as? String, let startDate = item[FirebaseUser.StartDate] as? Double, let finishDate = item[FirebaseUser.FinishDate] as? Double, let description = item[FirebaseUser.DescriptionOfProfession] as? String, let isCancelledAnnounce = item[FirebaseUser.IsCanceledAnnounce] as? Bool {
                        
                        var candidateIds: [String] = []
                        if let candidates = item[FirebaseUser.Candidates] as? [String:String] {
                            print("")
                        }
                        
                        let announce = AnnounceJob(id: announceItem.key,
                                                   occupationArea: occupationArea,
                                                   startTimestamp: startDate,
                                                   finishTimestamp: finishDate,
                                                   isCanceled: isCancelledAnnounce,
                                                   candidatesIds: candidateIds,
                                                   descriptionOfAnnounce: description)
                        
                        if onlyCancelledsAndFinisheds {
                            if announce.isCanceled /* e only finalizado */ {
                                announces.append(announce)
                            }
                        } else {
                            if !announce.isCanceled /* e only finalizado */ {
                                announces.append(announce)
                            }
                        }
                    }
                }
            }
            completion(announces)
        }
    }
}
