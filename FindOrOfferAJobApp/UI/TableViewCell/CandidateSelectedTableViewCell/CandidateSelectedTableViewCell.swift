//
//  CandidateSelectedTableViewCell.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 12/07/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class CandidateSelectedTableViewCell: UITableViewCell {

    @IBOutlet weak var userPhoto: UIImageView! {
        didSet {
            self.userPhoto.image = ImageConstants.ProflePlaceHolder
            self.userPhoto.layer.borderWidth = 1
            self.userPhoto.layer.masksToBounds = false
            self.userPhoto.layer.borderColor = UIColor.clear.cgColor
            self.userPhoto.layer.cornerRadius = self.userPhoto.frame.height/3.3
            self.userPhoto.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var celPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
