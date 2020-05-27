//
//  AnnounceDetailResumeTableViewCell.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 24/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class AnnounceDetailResumeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var professionalArea: UILabel!
    @IBOutlet weak var startAnnounceDate: UILabel!
    @IBOutlet weak var finalAnnounceDate: UILabel!
    @IBOutlet weak var announceDescription: UILabel!
    @IBOutlet weak var finalizeOrCanceledLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
