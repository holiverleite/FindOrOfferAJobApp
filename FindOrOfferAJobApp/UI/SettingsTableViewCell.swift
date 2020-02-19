//
//  SettingsTableViewCell.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 19/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            self.separatorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
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
