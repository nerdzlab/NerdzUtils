//
//  UILabel+NibLocalized.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import UIKit

public extension UILabel {
    
    /// Localized text 
    /// Useful for setting localized text from nib files
    @IBInspectable var textLocalization: String? {
        set {
            if let identifier = newValue {
                text = NSLocalizedString(identifier, comment: "")
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
    @IBInspectable var textLocalization: String? {
        set {
            if let identifier = newValue {
                text = NSLocalizedString(identifier, comment: "")
            }
        }
        
        get {
            nil
        }
    }
    
    /// Localized placeholder 
    /// Useful for setting localized placeholder from nib files
    @IBInspectable var placeholderLocalization: String? {
        set {
            if let identifier = newValue {
                placeholder = NSLocalizedString(identifier, comment: "")
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
    @IBInspectable var textLocalization: String? {
        set {
            if let identifier = newValue {
                setTitle(NSLocalizedString(identifier, comment: ""), for: .normal)
            }
        }
        
        get {
            nil
        }
    }
}
