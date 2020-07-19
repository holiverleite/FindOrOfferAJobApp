//
//  TextViewTableViewCell.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 19/07/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class TextViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            self.descriptionTextView.layer.borderWidth = 0.5
            self.descriptionTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
            self.descriptionTextView.layer.cornerRadius = 4.0
            self.descriptionTextView.font = UIFont.systemFont(ofSize: 20, weight: .thin)
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
