//
//  UserResumeTableViewCell.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 21/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class UserResumeTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            self.userImageView.layer.borderWidth = 1
            self.userImageView.layer.masksToBounds = false
            self.userImageView.layer.borderColor = UIColor.clear.cgColor
            self.userImageView.layer.cornerRadius = self.userImageView.frame.height/3
            self.userImageView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
