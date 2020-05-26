//
//  AnnouncesListCellTableViewCell.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 26/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class AnnouncesListCellTableViewCell: UITableViewCell {

    @IBOutlet weak var announceArea: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var totalOfCandidates: UILabel!
    @IBOutlet weak var totalCandidatesOrCancelledDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
