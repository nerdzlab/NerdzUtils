//
//  DateRange.swift
//  NerdzDate
//
//  Created by new user on 07.10.2020.
//

import Foundation
import NerdzCore

/// A signed amount of a single calendar unit, used to shift a date.
///
/// Build a range with one of the static factories and hand it to
/// ``NerdzDate/NerdzCore/NZExtensionData/adding(_:)`` or to the `+` operator on `Date`.
///
/// ```swift
/// let nextWeek = Date() + .day(7)
/// let lastMonth = Date().nz.adding(.month(-1))
/// ```
///
/// The value is applied through `Calendar.current`, so month and year arithmetic clamps the way
/// the calendar clamps it (adding one month to 31 January lands on the last day of February).
public struct DateRange {
    let component: Calendar.Component
    let value: Int
    
    fileprivate func fill(into components: inout DateComponents) {
        components[component] = value
    }
    
    /// Creates a range of seconds.
    ///
    /// - Parameter value: The number of seconds. Negative values shift a date backwards.
    /// - Returns: A range describing `value` seconds.
    public static func second(_ value: Int) -> DateRange {
        DateRange(component: .second, value: value)
    }
    
    /// Creates a range of minutes.
    ///
    /// - Parameter value: The number of minutes. Negative values shift a date backwards.
    /// - Returns: A range describing `value` minutes.
    public static func minute(_ value: Int) -> DateRange {
        DateRange(component: .minute, value: value)
    }
    
    /// Creates a range of hours.
    ///
    /// - Parameter value: The number of hours. Negative values shift a date backwards.
    /// - Returns: A range describing `value` hours.
    public static func hour(_ value: Int) -> DateRange {
        DateRange(component: .hour, value: value)
    }
    
    /// Creates a range of days.
    ///
    /// - Parameter value: The number of days. Negative values shift a date backwards.
    /// - Returns: A range describing `value` days.
    public static func day(_ value: Int) -> DateRange {
        DateRange(component: .day, value: value)
    }
    
    /// Creates a range of weeks counted inside the year.
    ///
    /// - Parameter value: The number of weeks. Negative values shift a date backwards.
    /// - Returns: A range describing `value` weeks of the year.
    public static func weekOfYear(_ value: Int) -> DateRange {
        DateRange(component: .weekOfYear, value: value)
    }
    
    /// Creates a range of weeks counted inside the month.
    ///
    /// - Parameter value: The number of weeks. Negative values shift a date backwards.
    /// - Returns: A range describing `value` weeks of the month.
    public static func weekOfMonth(_ value: Int) -> DateRange {
        DateRange(component: .weekOfMonth, value: value)
    }
    
    /// Creates a range of months.
    ///
    /// - Parameter value: The number of months. Negative values shift a date backwards.
    /// - Returns: A range describing `value` months.
    public static func month(_ value: Int) -> DateRange {
        DateRange(component: .month, value: value)
    }
    
    /// Creates a range of years.
    ///
    /// - Parameter value: The number of years. Negative values shift a date backwards.
    /// - Returns: A range describing `value` years.
    public static func year(_ value: Int) -> DateRange {
        DateRange(component: .year, value: value)
    }
}
