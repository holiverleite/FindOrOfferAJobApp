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

    // Announce Creation
    func addAnnounceJob(userId: String, announceJob: AnnounceJob, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = globalAnnounceReference.childByAutoId()
        let announceDict: [String: Any] = [
            FirebaseUser.AdOwner: userId,
            FirebaseUser.OccupationArea: announceJob.occupationArea,
            FirebaseUser.DescriptionOfProfession: announceJob.descriptionOfAnnounce,
            FirebaseUser.StartDate: announceJob.startTimestamp,
            FirebaseUser.FinishDate: announceJob.finishTimestamp,
            FirebaseUser.IsCanceledAnnounce: false,
            FirebaseUser.IsFinalizedAnnounce: false,
            FirebaseUser.IsProcessFinalizedAnnounce: false,
            FirebaseUser.Candidates: [:]
        ]
        
        ref.setValue(announceDict) { (error, databaseReference) in
            if error != nil {
                completion(false)
            } else {
                if let announceKey = databaseReference.key {
                    let ref = self.usersReference.child(userId).child(FirebaseUser.AnnounceJob)
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
    
    // When candidate is approved
    func approveCandidateOfAnnounce(candidateId: String, announceJob: AnnounceJob, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = globalAnnounceReference.child(announceJob.id)
        let announceDict: [String: Any] = [
            FirebaseUser.OccupationArea: announceJob.occupationArea,
            FirebaseUser.DescriptionOfProfession: announceJob.descriptionOfAnnounce,
            FirebaseUser.StartDate: announceJob.startTimestamp,
            FirebaseUser.FinishDate: Date().timeIntervalSince1970,
            FirebaseUser.IsCanceledAnnounce: false,
            FirebaseUser.IsFinalizedAnnounce: false,
            FirebaseUser.IsProcessFinalizedAnnounce: true,
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
        let ref = globalAnnounceReference.child(announceJob.id)
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
    
    func cancelJobApplication(userId: String, announceJob: AnnounceJob, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = globalAnnounceReference.child(announceJob.id).child(FirebaseUser.Candidates)
        ref.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let data = dataSnapshot.value as? [String: Any] else {
                return
            }
            
            var dictCandidates: [String:Any] = [:]
            for item in data {
                if item.key != userId {
                    dictCandidates[item.key] = item.key
                }
            }
            
            ref.setValue(dictCandidates) { (error, databaseReference) in
                if error != nil {
                    completion(false)
                } else {
                    let userRef = self.usersReference.child(userId).child(FirebaseUser.MyJobApplications)
                    userRef.observeSingleEvent(of: .value) { (dataSnapshot) in
                        guard let data = dataSnapshot.value as? [String: Any] else {
                            completion(false)
                            return
                        }
                        
                        var myJobApplications: [String:Any] = [:]
                        for item in data {
                            if item.key != announceJob.id {
                                myJobApplications[item.key] = item.key
                            }
                        }
                        
                        userRef.setValue(myJobApplications) { (error, databaseReference) in
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
    }
    
    func applyToJob(userId: String, announceJob: AnnounceJob, completion: @escaping (_ success: Bool?) -> Void) {
        let ref = self.usersReference.child(userId).child(FirebaseUser.MyJobApplications)
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
        let ref = self.globalAnnounceReference.child(announceJob.id).child(FirebaseUser.Candidates)
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
        let ref = self.globalAnnounceReference.child(announceJob.id)
        let announceDict: [String: Any] = [
            FirebaseUser.OccupationArea: announceJob.occupationArea,
            FirebaseUser.DescriptionOfProfession: announceJob.descriptionOfAnnounce,
            FirebaseUser.StartDate: announceJob.startTimestamp,
            FirebaseUser.FinishDate: announceJob.finishTimestamp,
            FirebaseUser.IsFinalizedAnnounce: false,
            FirebaseUser.IsProcessFinalizedAnnounce: false,
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
        let ref = self.globalAnnounceReference
        ref.observe(.value) { (dataSnapshot) in
            guard let data = dataSnapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var announces: [AnnounceJob] = []
            for announceItem in data {
                if let item = announceItem.value as? [String: Any] {
                    if let occupationArea = item[FirebaseUser.OccupationArea] as? String,
                        let ownerAnnounce = item[FirebaseUser.AdOwner] as? String,
                        let startDate = item[FirebaseUser.StartDate] as? Double,
                        let finishDate = item[FirebaseUser.FinishDate] as? Double,
                        let description = item[FirebaseUser.DescriptionOfProfession] as? String,
                        let isCancelledAnnounce = item[FirebaseUser.IsCanceledAnnounce] as? Bool,
                        let isFinalizedAnnounce = item[FirebaseUser.IsFinalizedAnnounce] as? Bool,
                        let isProccessFinalizedAnnounce = item[FirebaseUser.IsProcessFinalizedAnnounce] as? Bool {
                        
                        let currentUser = UserProfileViewModel()
                        if !isFinalizedAnnounce && !isCancelledAnnounce && !isProccessFinalizedAnnounce && currentUser.userId != ownerAnnounce {
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
    
    func retrieveAnnouncesForMe(professionalCards: [ProfessionalCard], completion: @escaping (_ announces: [AnnounceJob]) -> Void) {
        let ref = self.globalAnnounceReference
        ref.observe(.value) { (dataSnapshot) in
            guard let data = dataSnapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var occupations: [String] = []
            for card in professionalCards {
                let occupationArea = card.occupationArea
                occupations.append(occupationArea)
            }
            
            var announces: [AnnounceJob] = []
            
            for announceItem in data {
                if let item = announceItem.value as? [String: Any] {
                    
                    if let occupationArea = item[FirebaseUser.OccupationArea] as? String,
                        let startDate = item[FirebaseUser.StartDate] as? Double,
                        let finishDate = item[FirebaseUser.FinishDate] as? Double,
                        let description = item[FirebaseUser.DescriptionOfProfession] as? String,
                        let ownerAnnounce = item[FirebaseUser.AdOwner] as? String,
                        let isCancelledAnnounce = item[FirebaseUser.IsCanceledAnnounce] as? Bool,
                        let isFinalizedAnnounce = item[FirebaseUser.IsFinalizedAnnounce] as? Bool,
                        let isProccessFinalizedAnnounce = item[FirebaseUser.IsProcessFinalizedAnnounce] as? Bool {
                        
                        if occupations.contains(occupationArea) {
                            let currentUser = UserProfileViewModel()
                            if !isFinalizedAnnounce && !isCancelledAnnounce && !isProccessFinalizedAnnounce && currentUser.userId != ownerAnnounce {
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
            }
            completion(announces)
        }
    }
    
    func retrieveAnnouncesJob(userId: String, onlyCancelledsAndFinisheds: Bool = false, completion: @escaping (_ professionalCards: [AnnounceJob]) -> Void) {
        let ref = self.usersReference.child(userId).child(FirebaseUser.AnnounceJob)
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
                let ref = self.globalAnnounceReference.child(item)
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
                            let isFinalizedAnnounce = adDetail[FirebaseUser.IsFinalizedAnnounce] as? Bool,
                            let isProcessFinalizedAnnounce = adDetail[FirebaseUser.IsProcessFinalizedAnnounce] as? Bool {
                            
                            let selectedCandidate = adDetail[FirebaseUser.SelectedCandidate] as? String
                            
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
                                                       selectedCandidateId: selectedCandidate,
                                                       isFinished:  isFinalizedAnnounce,
                                                       isProcessFinished: isProcessFinalizedAnnounce)
                            
                            if onlyCancelledsAndFinisheds {
                                if announce.isCanceled || announce.isFinished /* e only finalizado */ {
                                    announces.append(announce)
                                }
                            } else {
                                if !announce.isCanceled && !announce.isFinished /* e only finalizado */ {
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
    
    
    // retrieve candiadte selected
    func retrieveAnnouncesJob(announceId: String, completion: @escaping (_ announce: AnnounceJob?) -> Void) {
        let ref = self.globalAnnounceReference.child(announceId)
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
                    let isFinalizedAnnounce = adDetail[FirebaseUser.IsFinalizedAnnounce] as? Bool,
                    let isProccessFinalizedAnnounce = adDetail[FirebaseUser.IsProcessFinalizedAnnounce] as? Bool {

                    announce = AnnounceJob(id: announceId,
                                               occupationArea: occupationArea,
                                               startTimestamp: startDate,
                                               finishTimestamp: finishDate,
                                               isCanceled: isCancelledAnnounce,
                                               candidatesIds: [],
                                               descriptionOfAnnounce: description,
                                               selectedCandidateId: selectedCandidate,
                                               isFinished: isFinalizedAnnounce,
                                               isProcessFinished: isProccessFinalizedAnnounce)
                    
                }
                completion(announce)
            }
        }
    }
    
    func retrieveMyJobApplications(userId: String, completion: @escaping (_ professionalCards: [AnnounceJob]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var appliedAnnouncesIds: [String] = []
        var myApplications: [AnnounceJob] = []
        
        let ref = self.usersReference.child(userId).child(FirebaseUser.MyJobApplications)
        dispatchGroup.enter()
        ref.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let data = dataSnapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            
            for item in data {
                let announceId = item.key
                appliedAnnouncesIds.append(announceId)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            let dispatchGroupIntern = DispatchGroup()
            
            for announceId in appliedAnnouncesIds {
                dispatchGroupIntern.enter()
                let ref = self.globalAnnounceReference.child(announceId)
                ref.observeSingleEvent(of: .value) { (dataSnapshot) in
                    guard let data = dataSnapshot.value as? [String: Any] else {
                        completion([])
                        return
                    }
                    
                    if let occupationArea = data[FirebaseUser.OccupationArea] as? String,
                        let startDate = data[FirebaseUser.StartDate] as? Double,
                        let finishDate = data[FirebaseUser.FinishDate] as? Double,
                        let description = data[FirebaseUser.DescriptionOfProfession] as? String,
                        let isCancelledAnnounce = data[FirebaseUser.IsCanceledAnnounce] as? Bool,
                        let isFinalizedAnnounce = data[FirebaseUser.IsFinalizedAnnounce] as? Bool,
                        let isProccessFinalizedAnnounce = data[FirebaseUser.IsProcessFinalizedAnnounce] as? Bool {
                        
                        let selectedCandidate = data[FirebaseUser.SelectedCandidate] as? String
                        
                        let announce = AnnounceJob(id: announceId,
                                                   occupationArea: occupationArea,
                                                   startTimestamp: startDate,
                                                   finishTimestamp: finishDate,
                                                   isCanceled: isCancelledAnnounce,
                                                   candidatesIds: [],
                                                   descriptionOfAnnounce: description,
                                                   selectedCandidateId: selectedCandidate,
                                                   isFinished:  isFinalizedAnnounce,
                                                   isProcessFinished: isProccessFinalizedAnnounce)
                        
                        myApplications.append(announce)
                    }
                    dispatchGroupIntern.leave()
                }
            }
            
            dispatchGroupIntern.notify(queue: .main) {
                completion(myApplications)
            }
        }
    }
}
