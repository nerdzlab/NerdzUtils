//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

#if canImport(UIKit)

import UIKit

public extension NZUtilsExtensionData where Base: UIView {
    
    /// View corner radius
    var cornerRadius: CGFloat {
        get { base.layer.cornerRadius }
        set { base.layer.cornerRadius = newValue }
    }
    
    /// View masked corners
    @available(iOS 11.0, macOS 10.12, *)
    var maskedCorners: CACornerMask {
        get { base.layer.maskedCorners }
        set { base.layer.maskedCorners = newValue }
    }
    
    /// View border width
    var borderWidth: CGFloat {
        get { base.layer.borderWidth }
        set { base.layer.borderWidth = newValue }
    }
    
    /// View border color
    var borderColor: UIColor? {
        get {
            if let color = base.layer.borderColor {
                return UIColor(cgColor: color)
            }
            
            return nil
        }
        set { base.layer.borderColor = newValue?.cgColor }
    }
    
    /// View shadow color
    var shadowColor: UIColor? {
        get {
            if let color = base.layer.shadowColor {
                return UIColor(cgColor: color)
            }
            
            return nil
        }
        set { base.layer.shadowColor = newValue?.cgColor }
    }
    
    /// View shadow opacity
    var shadowAlpha: Float {
        get { base.layer.shadowOpacity }
        set { base.layer.shadowOpacity = newValue }
    }
    
    /// View shadow offset
    var shadowOffset: CGSize {
        get { base.layer.shadowOffset }
        set { base.layer.shadowOffset = newValue }
    }
    
    /// View shadow radius
    var shadowBlur: CGFloat {
        get { base.layer.shadowRadius * 2 }
        set { base.layer.shadowRadius = newValue / 2 }
    }
}

public extension UIView {
    
    /// @IBInspectable view corner radius
    @IBInspectable var nz_cornerRadius: CGFloat {
        get { nz.cornerRadius }
        set { nz.cornerRadius = newValue }
    }
    
    /// @IBInspectable view border width
    @IBInspectable var nz_borderWidth: CGFloat {
        get { nz.borderWidth }
        set { nz.borderWidth = newValue }
    }
    
    /// @IBInspectable view border color
    @IBInspectable var nz_borderColor: UIColor? {
        get { nz.borderColor }
        set { nz.borderColor = newValue }
    }
    
    /// @IBInspectable view shadow color
    @IBInspectable var nz_shadowColor: UIColor? {
        get { nz.shadowColor }
        set { nz.shadowColor = newValue }
    }
    
    /// @IBInspectable view shadow opacity
    @IBInspectable var nz_shadowAlpha: Float {
        get { nz.shadowAlpha }
        set { nz.shadowAlpha = newValue }
    }
    
    /// @IBInspectable view shadow offset
    @IBInspectable var nz_shadowOffset: CGSize {
        get { nz.shadowOffset }
        set { nz.shadowOffset = newValue }
    }
    
    /// @IBInspectable view shadow radius
    @IBInspectable var nz_shadowBlur: CGFloat {
        get { nz.shadowBlur }
        set { nz.shadowBlur = newValue }
    }
}

#endif
