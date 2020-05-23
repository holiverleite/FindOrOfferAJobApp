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
    
    override init() {
        self.id = ""
        self.occupationArea = ""
        self.descriptionOfAnnounce = ""
    }
    
    init(id: String, occupationArea: String, descriptionOfAnnounce: String) {
        self.id = id
        self.occupationArea = occupationArea
        self.descriptionOfAnnounce = descriptionOfAnnounce
    }
}
