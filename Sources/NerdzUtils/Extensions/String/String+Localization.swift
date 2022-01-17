//
//  String+Localization.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import Foundation

public extension NZUtilsExtensionData where Base == String {
    /// Return localized representation of current string
    var localized: String {
        NSLocalizedString(base, comment: "")
    }
}
