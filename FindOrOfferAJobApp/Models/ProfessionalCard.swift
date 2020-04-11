//
//  ProfessionalCard.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 11/04/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

class ProfessionalCard: NSObject {
    
    var occupationArea: String = ""
    var experienceTime: String = ""
    
    override init() {
        self.occupationArea = ""
        self.experienceTime = ""
    }
    
    init(occupationArea: String, experienceTime: String) {
        self.occupationArea = occupationArea
        self.experienceTime = experienceTime
    }
}
