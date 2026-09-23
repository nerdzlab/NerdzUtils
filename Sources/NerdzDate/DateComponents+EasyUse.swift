//
//  DateComponents+EasyUse.swift
//  NerdzDate
//
//  Created by new user on 07.10.2020.
//

import Foundation
import NerdzCore

public extension DateComponents {

    /// Reads or writes a single component by its `Calendar.Component` key.
    ///
    /// The getter forwards to `value(for:)` and the setter to `setValue(_:for:)`, which turns the
    /// long list of named properties into one uniform accessor.
    ///
    /// ```swift
    /// var components = DateComponents()
    /// components[.day] = 12
    /// let day = components[.day]
    /// ```
    ///
    /// - Parameter component: The component to read or write.
    /// - Returns: The stored value, or `nil` when the component is not set.
    subscript(_ component: Calendar.Component) -> Int? {
        get {
            value(for: component)
        }
        
        set {
            setValue(newValue, for: component)
        }
    }
}
