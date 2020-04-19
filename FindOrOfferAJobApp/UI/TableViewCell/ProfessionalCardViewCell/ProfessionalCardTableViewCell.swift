//
//  ProfessionalCardTableViewCell.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 19/04/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class ProfessionalCardTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCardView: UIView! {
        didSet {
            self.backgroundCardView.layer.cornerRadius = 8
            self.backgroundCardView.layer.borderWidth = 0.5
            self.backgroundCardView.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
        }
    }
    @IBOutlet weak var professionalTitleLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var professionDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(professionaltitle: String, exp: String, professionDescription: String) {
        self.professionalTitleLabel.text = professionaltitle
        self.experienceLabel.text = exp
        self.professionDescriptionLabel.text = professionDescription
    }
    
}
