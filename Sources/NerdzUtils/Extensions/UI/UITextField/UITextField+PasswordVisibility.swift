//
//  UITextField+PasswordVisibility.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

#if canImport(UIKit)

import UIKit

public extension UITextField {
    
    /// Enabling password visibility view on text field
    @IBInspectable var nz_isPasswordVisiblityToggleEnabled: Bool {
        set {
            if newValue {
                addPasswordVisibilityToggle()
            }
            else {
                removePasswordVisibilityToggle()
            }
        }
        
        get {
            rightView != nil
        }
    }
    
    private func removePasswordVisibilityToggle() {
        rightView = nil
    }
    
    private func addPasswordVisibilityToggle() {
        let rightButton = UIButton(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightButton.addTarget(
            self,
            action: #selector(passwordVisibilityTogglePressed(_:)),
            for: .touchUpInside
        )
        rightButton.nz.borderColor = .blue
        rightButton.setImage(UIImage(named: "NZ_PasswordShow"), for: .selected)
        rightButton.setImage(UIImage(named: "NZ_PasswordHide"), for: .normal)
        rightButton.isSelected = true
        
        rightViewMode = .always
        rightView = rightButton
    }
    
    @objc
    private func passwordVisibilityTogglePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isSecureTextEntry = sender.isSelected
    }
    
}

#endif
