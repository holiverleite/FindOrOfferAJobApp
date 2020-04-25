//
//  ProfessionalCard.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 11/04/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

class ProfessionalCard: NSObject {
    
    var id: String = ""
    var occupationArea: String = ""
    var experienceTime: String = ""
    var descriptionOfProfession: String = ""
    
    override init() {
        self.id = ""
        self.occupationArea = ""
        self.experienceTime = ""
        self.descriptionOfProfession = ""
    }
    
    init(id: String, occupationArea: String, experienceTime: String, descriptionOfProfession: String) {
        self.id = id
        self.occupationArea = occupationArea
        self.experienceTime = experienceTime
        self.descriptionOfProfession = descriptionOfProfession
    }
}
