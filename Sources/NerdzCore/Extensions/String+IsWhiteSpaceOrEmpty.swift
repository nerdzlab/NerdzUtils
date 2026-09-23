//
//  String+IsWhiteSpaceOrEmpty.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 17.02.2022.
//

import Foundation

import Foundation

public extension NZExtensionData where Base == String {
    /// A Boolean value indicating whether the string is empty or made only of whitespace.
    ///
    /// Whitespace here means the `whitespacesAndNewlines` character set, so spaces, tabs and line
    /// breaks all count as blank.
    ///
    /// ```swift
    /// "  \n".nz.isWhiteSpaceOrEmpty  // true
    /// " a ".nz.isWhiteSpaceOrEmpty   // false
    /// ```
    var isWhiteSpaceOrEmpty: Bool {
        base.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
