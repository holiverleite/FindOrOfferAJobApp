//
//  ProfessionalCardViewModel.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 11/04/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

struct ProfessionalCardViewModel {
    private let professionalCard: ProfessionalCard
    
    init() {
        self.professionalCard = ProfessionalCard()
    }
    
    var occupationArea: String {
        return self.professionalCard.occupationArea
    }
    
    var experienceTime: String {
        return self.professionalCard.experienceTime
    }
}
