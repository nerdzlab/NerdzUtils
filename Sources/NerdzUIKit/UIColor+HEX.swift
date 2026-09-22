//
//  File.swift
//  
//
//  Created by new user on 31.08.2021.
//

import Foundation

#if canImport(UIKit)

import UIKit

public extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {

        // Convert hex string to an integer
        let hexint = UIColor.integer(from: hex)
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0

        // Create color object, specifying alpha as well
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    static private func integer(from hexString: String) -> Int {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexString)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return Int(hexInt)
    }
}

#endif
