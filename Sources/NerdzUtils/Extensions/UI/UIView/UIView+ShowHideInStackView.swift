//
//  UIView+ShowHideInStackView.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 27.08.2024.
//

#if canImport(UIKit)

import UIKit

public extension NZUtilsExtensionData where Base: UIView {
    
    // Method to show
    // This method will work only for views that added to superview and not hidden
    @available(iOS 11.0, macOS 10.12, *)
    func hideAnimated(in stackView: UIStackView, duration: CGFloat = 0.35) {
        guard !base.isHidden else {
            return
        }
        
        UIView.animate(
            withDuration: duration,
            animations: { [weak base] in
                base?.isHidden = true
                base?.alpha = 0
                
                stackView.layoutIfNeeded()
            }
        )
    }
    
    @available(iOS 11.0, macOS 10.12, *)
    func showAnimated(in stackView: UIStackView, duration: CGFloat = 0.35) {
        guard base.isHidden else {
            return
        }
        
        UIView.animate(
            withDuration: duration,
            animations: { [weak base] in
                base?.isHidden = false
                base?.alpha = 1
                
                stackView.layoutIfNeeded()
            }
        )
    }
}

#endif
