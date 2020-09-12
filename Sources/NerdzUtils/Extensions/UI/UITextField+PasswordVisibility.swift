//
//  UITextField+PasswordVisibility.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import UIKit

public extension UITextField {
    
    @IBInspectable
    var isPasswordVisiblityToggleEnabled: Bool {
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
    
    @IBAction private func passwordVisibilityTogglePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isSecureTextEntry = sender.isSelected
    }
    
    private func removePasswordVisibilityToggle() {
        rightView = nil
    }
    
    private func addPasswordVisibilityToggle() {
        let rightButton  = UIButton(type: .custom)
        rightButton.frame = CGRect(x:0, y:0, width:30, height:30)
        rightButton.addTarget(self, action: #selector(passwordVisibilityTogglePressed(_:)), for: .touchUpInside)
        rightButton.setImage(UIImage(named: "PasswordShow"), for: .selected)
        rightButton.setImage(UIImage(named: "PasswordHide"), for: .normal)
        rightButton.isSelected = true
        
        rightViewMode = .always
        rightView = rightButton
    }
}
