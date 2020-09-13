//
//  UILabel+NibLocalized.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import UIKit

public extension UILabel {
    
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
