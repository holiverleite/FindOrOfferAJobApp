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
        let ref = rootUsersReference.child(FirebaseUser.GlobalAnnounces).childByAutoId()
        let announceDict: [String: Any] = [
            FirebaseUser.AdOwner: userId,
            FirebaseUser.OccupationArea: announceJob.occupationArea,
            FirebaseUser.DescriptionOfProfession: announceJob.descriptionOfAnnounce,
            FirebaseUser.StartDate: announceJob.startTimestamp,
            FirebaseUser.FinishDate: announceJob.finishTimestamp,
            FirebaseUser.IsCanceledAnnounce: announceJob.isCanceled,
            FirebaseUser.IsFinalizedAnnounce: false,
            FirebaseUser.Candidates: [:]
        ]
        
        ref.setValue(announceDict) { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                if let announceKey = databaseReference.key {
                    let ref = self.rootUsersReference.child(userId).child(FirebaseUser.AnnounceJob)
                    let announceDict: [String: Any] = [
                        announceKey: announceKey
                    ]
                    
                    ref.updateChildValues(announceDict) { (error, databaseReference) in
                        if error != nil {
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    
    func approveCandidateOfAnnounce(candidateId: String, announceJob: AnnounceJob, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = rootUsersReference.child(FirebaseUser.GlobalAnnounces).child(announceJob.id)
        let announceDict: [String: Any] = [
            FirebaseUser.OccupationArea: announceJob.occupationArea,
            FirebaseUser.DescriptionOfProfession: announceJob.descriptionOfAnnounce,
            FirebaseUser.StartDate: announceJob.startTimestamp,
            FirebaseUser.FinishDate: Date().timeIntervalSince1970,
            FirebaseUser.IsCanceledAnnounce: false,
            FirebaseUser.IsFinalizedAnnounce: true,
            FirebaseUser.SelectedCandidate: candidateId,
            FirebaseUser.Candidates: [candidateId:candidateId]
        ]
        
        ref.setValue(announceDict) { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func cancelAnnounceJob(userId: String, announceJob: AnnounceJob, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = rootUsersReference.child(FirebaseUser.GlobalAnnounces).child(announceJob.id)
        let announceDict: [String: Any] = [
            FirebaseUser.OccupationArea: announceJob.occupationArea,
            FirebaseUser.DescriptionOfProfession: announceJob.descriptionOfAnnounce,
            FirebaseUser.StartDate: announceJob.startTimestamp,
            FirebaseUser.FinishDate: announceJob.finishTimestamp,
            FirebaseUser.IsCanceledAnnounce: true,
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
    
    func applyToJob(userId: String, announceJob: AnnounceJob, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = self.rootUsersReference.child(userId).child(FirebaseUser.MyJobApplications)
        let announceDict: [String: Any] = [
            announceJob.id: announceJob.id
        ]
        
        ref.updateChildValues(announceDict) { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                self.updateGlobalJobs(userId: userId, announceJob: announceJob) { (success) in
                    if success {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func updateGlobalJobs(userId: String, announceJob: AnnounceJob, completion: @escaping (_ success: Bool) -> Void) {
        let ref = self.rootUsersReference.child(FirebaseUser.GlobalAnnounces).child(announceJob.id).child(FirebaseUser.Candidates)
        let announceDict: [String: Any] = [
            userId: userId
        ]
        
        ref.updateChildValues(announceDict) { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
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
                    
                    if let occupationArea = item[FirebaseUser.OccupationArea] as? String,
                        let startDate = item[FirebaseUser.StartDate] as? Double,
                        let finishDate = item[FirebaseUser.FinishDate] as? Double,
                        let description = item[FirebaseUser.DescriptionOfProfession] as? String,
                        let isCancelledAnnounce = item[FirebaseUser.IsCanceledAnnounce] as? Bool,
                        let isFinalizedAnnounce = item[FirebaseUser.IsFinalizedAnnounce] as? Bool {
                        
                        if !isFinalizedAnnounce {
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
            }
            completion(announces)
        }
    }
    
    func retrieveAnnouncesJob(userId: String, onlyCancelledsAndFinisheds: Bool = false, completion: @escaping (_ professionalCards: [AnnounceJob]) -> Void) {
        let ref = self.rootUsersReference.child(userId).child(FirebaseUser.AnnounceJob)
        ref.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let data = dataSnapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var announces: [AnnounceJob] = []
            var myAnnouncesIds: [String] = []
            for announceItem in data {
                myAnnouncesIds.append(announceItem.key)
            }
            
            for item in myAnnouncesIds {
                let ref = self.rootUsersReference.child(FirebaseUser.GlobalAnnounces).child(item)
                ref.observeSingleEvent(of: .value) { (dataSnapshot) in
                    guard let data = dataSnapshot.value as? [String: Any] else {
                        completion([])
                        return
                    }
                    
                    if let adDetail = data as? [String: Any] {
                        if let occupationArea = adDetail[FirebaseUser.OccupationArea] as? String,
                            let startDate = adDetail[FirebaseUser.StartDate] as? Double,
                            let finishDate = adDetail[FirebaseUser.FinishDate] as? Double,
                            let description = adDetail[FirebaseUser.DescriptionOfProfession] as? String,
                            let isCancelledAnnounce = adDetail[FirebaseUser.IsCanceledAnnounce] as? Bool,
                            let isFinalizedAnnounce = adDetail[FirebaseUser.IsFinalizedAnnounce] as? Bool {
                            
                            var candidateIds: [String] = []
                            if let candidates = adDetail[FirebaseUser.Candidates] as? [String: String] {
                                for candidateId in candidates.values {
                                    candidateIds.append(candidateId)
                                }
                            }
                            
                            let announce = AnnounceJob(id: item,
                                                       occupationArea: occupationArea,
                                                       startTimestamp: startDate,
                                                       finishTimestamp: finishDate,
                                                       isCanceled: isCancelledAnnounce,
                                                       candidatesIds: candidateIds,
                                                       descriptionOfAnnounce: description,
                                                       isFinished:  isFinalizedAnnounce)
                            
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
                        completion(announces)
                    }
                }
            }
        }
    }
    
    func retrieveAnnouncesJob(announceId: String, completion: @escaping (_ announce: AnnounceJob?) -> Void) {
        let ref = self.rootUsersReference.child(FirebaseUser.GlobalAnnounces).child(announceId)
        ref.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let data = dataSnapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            var announce: AnnounceJob?
            if let adDetail = data as? [String: Any] {
                if let occupationArea = adDetail[FirebaseUser.OccupationArea] as? String,
                    let selectedCandidate = adDetail[FirebaseUser.SelectedCandidate] as? String,
                    let startDate = adDetail[FirebaseUser.StartDate] as? Double,
                    let finishDate = adDetail[FirebaseUser.FinishDate] as? Double,
                    let description = adDetail[FirebaseUser.DescriptionOfProfession] as? String,
                    let isCancelledAnnounce = adDetail[FirebaseUser.IsCanceledAnnounce] as? Bool,
                    let isFinalizedAnnounce = adDetail[FirebaseUser.IsFinalizedAnnounce] as? Bool {

                    announce = AnnounceJob(id: announceId,
                                               occupationArea: occupationArea,
                                               startTimestamp: startDate,
                                               finishTimestamp: finishDate,
                                               isCanceled: isCancelledAnnounce,
                                               candidatesIds: [],
                                               descriptionOfAnnounce: description,
                                               selectedCandidateId: selectedCandidate,
                                               isFinished:  isFinalizedAnnounce)
                    
                }
                completion(announce)
            }
        }
    }
}
