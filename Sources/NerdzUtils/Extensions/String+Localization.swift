//
//  String+Localization.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import Foundation

public extension String {
    
    private var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
