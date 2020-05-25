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
    
    init(id: String, occupationArea: String, startTimestamp: Double = 0.0, finishTimestamp: Double = 0.0, descriptionOfAnnounce: String) {
        self.id = id
        self.occupationArea = occupationArea
        self.descriptionOfAnnounce = descriptionOfAnnounce
        self.startTimestamp = startTimestamp
        self.finishTimestamp = finishTimestamp
    }
}
