//
//  UIColor+Inversed.swift
//  NerdzUtils
//
//  Created by new user on 08.11.2020.
//

import UIKit

public extension UIColor {
    
    var inversed: UIColor {
        var alpha: CGFloat = 1.0
        
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: alpha)
        }
        
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: 1.0 - hue, saturation: 1.0 - saturation, brightness: 1.0 - brightness, alpha: alpha)
        }
        
        var white: CGFloat = 0.0
        if self.getWhite(&white, alpha: &alpha) {
            return UIColor(white: 1.0 - white, alpha: alpha)
        }
        
        return self
    }
}
