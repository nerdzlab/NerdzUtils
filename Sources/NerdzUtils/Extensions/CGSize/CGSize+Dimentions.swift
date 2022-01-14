//
//  CGSize+Dimentions.swift
//  NerdzUtils
//
//  Created by new user on 19.05.2021.
//

import CoreGraphics

extension CGSize: NZUtilsExtensionCompatible { }

public extension NZUtilsExtensionData where Base == CGSize {
    /// Minimal size with ratio 16x9
    static var w16_h9: CGSize {
        CGSize(width: 16, height: 9)
    }
    
    /// Minimal size with ratio 9x16
    static var w9_h16: CGSize {
        CGSize(width: 9, height: 16)
    }
    
    /// Minimal size with ratio 4x3
    static var w4_h3: CGSize {
        CGSize(width: 4, height: 3)
    }
    
    /// Minimal size with ratio 3x4
    static var w3_h4: CGSize {
        CGSize(width: 3, height: 4)
    }
    
    /// Scaling size by factor
    /// - Parameter factor: Scale factor
    func scaled(by factor: CGFloat) -> CGSize {
        CGSize(width: base.width * factor, height: base.height * factor)
    }
}
