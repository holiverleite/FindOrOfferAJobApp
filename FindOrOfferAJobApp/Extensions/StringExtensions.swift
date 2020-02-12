//
//  StringExtensions.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 12/02/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

extension String {
    static func localize(_ string: String) -> String {
        return NSLocalizedString(string, comment: "")
    }
}
