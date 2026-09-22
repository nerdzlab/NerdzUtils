//
//  UIButton+Localized.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 14.01.2022.
//

#if os(iOS)

import UIKit
import NerdzCore

@MainActor
public extension NZExtensionData where Base: UIButton {
    /// Localized text
    /// Useful for setting localized text from nib files
    var textLocalization: String? {
        nonmutating set {
            if let identifier = newValue {
                base.setTitle(identifier.nz.localized, for: .normal)
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
