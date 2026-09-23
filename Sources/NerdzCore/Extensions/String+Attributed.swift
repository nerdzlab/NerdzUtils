//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

public extension NZExtensionData where Base == String {
    /// Wraps the string into an attributed string with the given attributes.
    ///
    /// ```swift
    /// let title = "Hello".nz.attributed(with: [.foregroundColor: UIColor.red])
    /// ```
    ///
    /// - Parameter attributes: The attributes applied to the whole string.
    /// - Returns: An attributed string holding the receiver and the given attributes.
    func attributed(with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return NSAttributedString(string: base, attributes: attributes)
    }
}

