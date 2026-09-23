//
//  Date+EasyUse.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import Foundation
import NerdzCore

public extension NZExtensionData where Base == Date {

    /// The current moment.
    ///
    /// A spelling of `Date()` that reads well inside the `.nz` namespace.
    static var now: Date {
        Date()
    }

    /// The date broken into every calendar component the library knows about.
    ///
    /// The components come from `Calendar.current` and cover the full list of
    /// `Calendar.Component.nz.allComponents`, so the result also carries `calendar` and `timeZone`
    /// and can be converted back into the original date with `Calendar.date(from:)`.
    var allComponents: DateComponents {
        Calendar.current.dateComponents(Set(Calendar.Component.nz.allComponents), from: base)
    }
    
    /// Checks whether another date falls on the same calendar day as this one.
    ///
    /// The comparison uses `Calendar.current`, so the day boundaries follow the current time zone.
    ///
    /// - Parameter date: The date to compare against.
    /// - Returns: `true` when both dates share the same calendar day.
    func isInSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: base)
    }
    
    /// Shifts the date by a calendar amount.
    ///
    /// The shift is performed by `Calendar.current`, so it respects daylight saving transitions
    /// and clamps overflowing days (adding one month to 31 January lands on the last day of
    /// February). The `+` operator on `Date` is a shorthand for this method.
    ///
    /// - Parameter range: The amount to add. Negative values move the date backwards.
    /// - Returns: The shifted date, or the original date when the calendar cannot produce a result.
    func adding(_ range: DateRange) -> Date {
        return Calendar.current.date(byAdding: range.component, value: range.value, to: base) ?? base
    }
    
    /// The first instant of the calendar unit that contains the date.
    ///
    /// The unit is resolved with `Calendar.dateInterval(of:for:)` on `Calendar.current`, so
    /// `start(of: .month)` lands on the first day of that month at midnight, `start(of: .year)`
    /// on 1 January at midnight, and `start(of: .day)` on midnight of the same day.
    ///
    /// The two week units behave differently on purpose. `weekOfYear` and `weekOfMonth` always
    /// snap back to the most recent Sunday at midnight and ignore the calendar's `firstWeekday`,
    /// so the result is the same in every locale even where the week starts on Monday. This is
    /// deliberate and is kept for compatibility with existing call sites.
    ///
    /// - Parameter component: The unit to align to, for example `.day`, `.month` or `.year`.
    /// - Returns: The first instant of that unit, or the original date when the calendar cannot
    ///   produce an interval for the component (`.calendar` and `.timeZone`, for instance).
    func start(of component: Calendar.Component) -> Date {
        interval(of: component)?.start ?? base
    }

    /// The last full second of the calendar unit that contains the date.
    ///
    /// The value is one second before the next unit begins, so `end(of: .day)` is 23:59:59 of that
    /// day and `end(of: .month)` is 23:59:59 of its last day. The unit is resolved with
    /// `Calendar.dateInterval(of:for:)` on `Calendar.current`.
    ///
    /// As with ``start(of:)``, `weekOfYear` and `weekOfMonth` are anchored to Sunday and ignore the
    /// calendar's `firstWeekday`, so they end on Saturday at 23:59:59 in every locale.
    ///
    /// - Parameter component: The unit to align to, for example `.day`, `.month` or `.year`.
    /// - Returns: One second before the next unit starts, or the original date when the calendar
    ///   cannot produce an interval for the component.
    func end(of component: Calendar.Component) -> Date {
        guard let interval = interval(of: component) else {
            return base
        }

        return interval.end.nz.adding(.second(DateUnit.lastSecondOffset))
    }

    private func interval(of component: Calendar.Component) -> DateInterval? {
        let calendar = Calendar.current

        guard component == .weekOfYear || component == .weekOfMonth else {
            return calendar.dateInterval(of: component, for: base)
        }

        let weekday = calendar.component(.weekday, from: base)
        let start = calendar.startOfDay(for: base).nz.adding(.day(DateUnit.sundayWeekday - weekday))

        return DateInterval(start: start, end: start.nz.adding(.day(DateUnit.daysInWeek)))
    }
}

private enum DateUnit {
    static let sundayWeekday = 1
    static let daysInWeek = 7
    static let lastSecondOffset = -1
}

public extension Date {

    /// Reads a single calendar component of the date.
    ///
    /// The value comes from `Calendar.current`, so `date[.day]` is the day of the month and
    /// `date[.weekday]` is a number from 1 (Sunday) to 7 (Saturday).
    ///
    /// The subscript is read only and never returns `nil`. Components that carry no numeric value,
    /// such as `.calendar` and `.timeZone`, produce the undefined marker that
    /// `Calendar.component(_:from:)` returns for them.
    ///
    /// - Parameter component: The component to read.
    /// - Returns: The value of that component in the current calendar.
    subscript(_ component: Calendar.Component) -> Int? {
        get {
            Calendar.current.component(component, from: self)
        }
    }
    
    /// Shifts a date forward by a calendar amount.
    ///
    /// A shorthand for `lhs.nz.adding(rhs)`, which lets call sites read as `Date() + .day(7)`.
    ///
    /// - Parameters:
    ///   - lhs: The date to shift.
    ///   - rhs: The amount to add. Negative values move the date backwards.
    /// - Returns: The shifted date.
    static func + (lhs: Self, rhs: DateRange) -> Self {
        lhs.nz.adding(rhs)
    }
}
