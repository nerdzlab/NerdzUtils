//
//  CGSize+Dimentions.swift
//  NerdzUtils
//
//  Created by new user on 19.05.2021.
//

import CoreGraphics

public extension CGSize {
    static var w16_h9: CGSize {
        CGSize(width: 16, height: 9)
    }
    
    static var w9_h16: CGSize {
        CGSize(width: 9, height: 16)
    }
    
    static var w4_h3: CGSize {
        CGSize(width: 4, height: 3)
    }
    
    static var w3_h4: CGSize {
        CGSize(width: 3, height: 4)
    }
    
    func scaled(by factor: CGFloat) -> CGSize {
        CGSize(width: width * factor, height: height * factor)
    }
}
