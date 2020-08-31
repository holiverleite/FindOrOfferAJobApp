//
//  InputTableViewCell.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 21/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

protocol CustomTextFieldDelegate: class {
    func textFieldDidChanged(_ textField: UITextField, type: ProfileOptions)
    func textFieldDidEndEditing(_ textField: UITextField, type: ProfileOptions)
}

class InputTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCellView: UIView! {
        didSet {
            backgroundCellView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTouchBackground)))
        }
    }
    @IBOutlet weak var inputDescription: UILabel!
    @IBOutlet weak var inputTextField: UITextField! {
        didSet {
            self.inputTextField.delegate = self
            self.inputTextField.borderStyle = .roundedRect
            self.inputTextField.layer.borderColor = UIColor.lightGray.cgColor
            self.inputTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        }
    }
    
    var positionY: CGRect = .zero
    var type: ProfileOptions = .Nome
    weak var delegate: CustomTextFieldDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func textFieldDidChanged() {
        self.delegate?.textFieldDidChanged(self.inputTextField, type: self.type)
    }
    
    @objc func didTouchBackground() {
        self.endEditing(true)
    }
}

extension InputTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidEndEditing(self.inputTextField, type: self.type)
    }
}
