//
//  UITextField+Localized.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 14.01.2022.
//

#if canImport(UIKit)

import UIKit

public extension NZUtilsExtensionData where Base: UITextField {
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
    
    /// Localized placeholder
    /// Useful for setting localized placeholder from nib files
    var placeholderLocalization: String? {
        set {
            if let identifier = newValue {
                base.placeholder = NSLocalizedString(identifier, comment: "")
            }
        }
        
        get {
            nil
        }
    }
}

public extension UITextField {
    
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
    
    /// Localized placeholder
    /// Useful for setting localized placeholder from nib files
    @IBInspectable var nz_placeholderLocalization: String? {
        set {
            nz.placeholderLocalization = newValue
        }
        
        get {
            nz.placeholderLocalization
        }
    }
}

#endif
