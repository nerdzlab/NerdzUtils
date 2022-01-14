//
//  UILabel+NibLocalized.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

#if canImport(UIKit)

import UIKit

public extension NZUtilsExtensionData where Base: UILabel {
    
    /// Localized text
    /// Useful for setting localized text from nib files
    var textLocalization: String? {
        set {
            if let identifier = newValue {
                base.text = NSLocalizedString(identifier, comment: "")
            }
        }
        
        get {
            nil
        }
    }
}

public extension UILabel {
    
    /// Localized text
    /// Useful for setting localized text from nib files
    @IBInspectable var nz_textLocalization: String? {
        set {
            nz.textLocalization = newValue
        }
        
        get {
            nz.textLocalization
        }
    }
}

#endif
