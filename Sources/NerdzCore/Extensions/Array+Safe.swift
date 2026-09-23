//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

public extension Array {
    
    /// Returns the element at the given index, or `nil` when the index is out of bounds.
    ///
    /// Use it instead of the regular subscript when the index comes from an untrusted source and
    /// a crash on an out of bounds access is not acceptable.
    ///
    /// ```swift
    /// let names = ["Ann", "Bob"]
    /// names[safe: 1]  // "Bob"
    /// names[safe: 5]  // nil
    /// ```
    ///
    /// - Parameter index: The position of the element to read.
    /// - Returns: The element at `index`, or `nil` when `index` is negative or not smaller than the
    ///   number of elements.
    subscript(safe index: Int) -> Element? {
        if 0..<self.count ~= index {
            return self[index]
        }

        return nil
    }
}
