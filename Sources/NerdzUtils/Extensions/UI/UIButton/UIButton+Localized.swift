//
//  UIButton+Localized.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 14.01.2022.
//

#if canImport(UIKit)

import UIKit

public extension NZUtilsExtensionData where Base: UIButton {
    /// Localized text
    /// Useful for setting localized text from nib files
    var textLocalization: String? {
        set {
            if let identifier = newValue {
                base.setTitle(NSLocalizedString(identifier, comment: ""), for: .normal)
            }
        }
        
        get {
            nil
        }
    }
}

public extension UIButton {
    
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
