//
//  AnnounceJob.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 23/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

class AnnounceJob: NSObject {
    
    var id: String = ""
    var occupationArea: String = ""
    var descriptionOfAnnounce: String = ""
    var startTimestamp: Double = 0.0
    var finishTimestamp: Double = 0.0
    var candidatesIds: [String] = []
    var selectedCandidateId: String?
    var isCanceled: Bool = false
    var isProcessFinished: Bool = false
    var isFinished: Bool = false
    
    init(id: String,
         occupationArea: String,
         startTimestamp: Double = 0.0,
         finishTimestamp: Double = 0.0,
         isCanceled: Bool = false,
         candidatesIds: [String] = [],
         descriptionOfAnnounce: String,
         selectedCandidateId: String? = nil,
         isFinished: Bool = false,
         isProcessFinished: Bool = false) {
        self.id = id
        self.occupationArea = occupationArea
        self.descriptionOfAnnounce = descriptionOfAnnounce
        self.startTimestamp = startTimestamp
        self.isCanceled = isCanceled
        self.finishTimestamp = finishTimestamp
        self.candidatesIds = candidatesIds
        self.selectedCandidateId = selectedCandidateId
        self.isFinished = isFinished
        self.isProcessFinished = isProcessFinished
    }
}
