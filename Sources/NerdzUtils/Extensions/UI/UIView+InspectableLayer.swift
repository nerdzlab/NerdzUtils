//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import UIKit

public extension UIView {
    
    /// View corner radius
    @IBInspectable var viewCornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    /// View border width
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    /// View border color
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    /// View shadow color
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    /// View shadow opacity
    @IBInspectable var shadowAlpha: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    /// View shadow offset
    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    /// View shadow radius
    @IBInspectable var shadowBlur: CGFloat {
        get { return layer.shadowRadius * 2 }
        set { layer.shadowRadius = newValue / 2 }
    }
}
