//
//  File.swift
//  
//
//  Created by Mykhailo on 06.04.2021.
//

import Foundation
import NerdzCore

public extension NZExtensionData where Base == Date {

    /// A day of the week, numbered the way the Gregorian calendar numbers it.
    ///
    /// The raw values match `Calendar.Component.weekday`, so `sunday` is 1 and `saturday` is 7.
    enum Weekday: Int {
        /// Sunday, weekday number 1.
        case sunday = 1

        /// Monday, weekday number 2.
        case monday

        /// Tuesday, weekday number 3.
        case tuesday

        /// Wednesday, weekday number 4.
        case wednesday

        /// Thursday, weekday number 5.
        case thursday

        /// Friday, weekday number 6.
        case friday

        /// Saturday, weekday number 7.
        case saturday
    }
    
    /// The next occurrence of a weekday after this date.
    ///
    /// The search runs on a Gregorian calendar in the current time zone, independent of the
    /// user's calendar setting. A found date is the start of that day at midnight.
    ///
    /// - Parameters:
    ///   - weekday: The weekday to look for.
    ///   - considerToday: When `true` and the date already falls on `weekday`, the date itself is
    ///     returned unchanged, keeping its time of day. Defaults to `false`, which always moves
    ///     forward to the following week.
    /// - Returns: The matching date, or `nil` when the calendar finds no match.
    func next(
        _ weekday: Weekday,
        considerToday: Bool = false
    ) -> Date? {
        findWeekDayDate(weekday, direction: .forward, considerToday: considerToday)
    }
    
    /// The previous occurrence of a weekday before this date.
    ///
    /// The search runs on a Gregorian calendar in the current time zone, independent of the
    /// user's calendar setting. A found date is the start of that day at midnight.
    ///
    /// - Parameters:
    ///   - weekday: The weekday to look for.
    ///   - considerToday: When `true` and the date already falls on `weekday`, the date itself is
    ///     returned unchanged, keeping its time of day. Defaults to `false`, which always moves
    ///     back to the preceding week.
    /// - Returns: The matching date, or `nil` when the calendar finds no match.
    func previous(
        _ weekday: Weekday,
        considerToday: Bool = false
    ) -> Date? {
        findWeekDayDate(weekday, direction: .backward, considerToday: considerToday)
    }
    
    private func findWeekDayDate(
        _ weekday: Weekday,
        direction: Calendar.SearchDirection = .forward,
        considerToday: Bool = false
    ) -> Date? {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(weekday: weekday.rawValue)
        
        if considerToday && calendar.component(.weekday, from: base) == weekday.rawValue {
            return base
        }
        
        return calendar.nextDate(
            after: base,
            matching: components,
            matchingPolicy: .nextTime,
            direction: direction
        )
    }
}
