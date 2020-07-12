//
//  FirebaseConstants.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 18/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

struct FirebaseKnot {
    static let Users = "users"
}

struct FirebaseUser {
    // Personal
    static let FirstName = "firstName"
    static let LastName = "lastName"
    static let Email = "email"
    static let Cellphone = "cellphone"
    static let Phone = "phone"
    static let TypeAccount = "typeAccount"
    static let UserImageURL = "userImageURL"
    static let BirthDate = "birthDate"
    // Professional
    static let ProfessionalCards = "professionalCards"
    static let OccupationArea = "occupationArea"
    static let StartDate = "startDate"
    static let FinishDate = "finishDate"
    static let ExperienceTime = "experienceTime"
    static let DescriptionOfProfession = "description"
    // Announce
    static let AnnounceJob = "announceJob"
    static let Candidates = "candidates"
    static let IsCanceledAnnounce = "isCanceled"
    static let IsFinalizedAnnounce = "isFinalized"
    static let GlobalAnnounces = "globalAnnounces"
    static let MyJobApplications = "myJobApplications"
    static let AdOwner = "adOwner"
    static let SelectedCandidate = "selectedCandidate"
}
