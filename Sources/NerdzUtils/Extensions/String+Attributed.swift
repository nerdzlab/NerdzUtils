//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

public extension String {    
    /// Form an attributed string from `String` class
    /// - Parameter attributes: An array of attributes that needs to be applied
    /// - Returns: Transformed attributed string
    func attributed(with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
}
