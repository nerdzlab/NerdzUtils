//
//  Date+EasyUse.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import Foundation
import NerdzCore

public extension NZExtensionData where Base == Date {
    static var now: Date {
        Date()
    }

    var allComponents: DateComponents {
        Calendar.current.dateComponents(Set(Calendar.Component.nz.allComponents), from: base)
    }
    
    func isInSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: base)
    }
    
    func adding(_ range: DateRange) -> Date {
        return Calendar.current.date(byAdding: range.component, value: range.value, to: base) ?? base
    }
    
    func start(of component: Calendar.Component) -> Date {
        interval(of: component)?.start ?? base
    }

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
    subscript(_ component: Calendar.Component) -> Int? {
        get {
            Calendar.current.component(component, from: self)
        }
    }
    
    static func + (lhs: Self, rhs: DateRange) -> Self {
        lhs.nz.adding(rhs)
    }
}
