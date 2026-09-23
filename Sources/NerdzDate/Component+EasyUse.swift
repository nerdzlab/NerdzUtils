//
//  Component+EasyUse.swift
//  NerdzDate
//
//  Created by new user on 07.10.2020.
//

import Foundation
import NerdzCore

extension Calendar.Component: NZExtensionCompatible { }

public extension NZExtensionData where Base == Calendar.Component {
    
    /// Every calendar component the library knows about.
    ///
    /// The list contains `nanosecond`, `second`, `minute`, `hour`, `day`, `month`, `year`, `era`,
    /// `weekday`, `weekdayOrdinal`, `quarter`, `weekOfMonth`, `weekOfYear`, `timeZone`,
    /// `yearForWeekOfYear` and `calendar`. On iOS 17, macOS 14, tvOS 17 and watchOS 10 or newer it
    /// also contains `isLeapMonth`, which does not exist on earlier systems.
    ///
    /// `Date.nz.allComponents` uses this list to ask the calendar for a fully populated
    /// `DateComponents` value.
    static var allComponents: [Calendar.Component] {
        var components: [Calendar.Component] = [
            Base.nanosecond,
            Base.second,
            Base.minute,
            Base.hour,
            Base.day,
            Base.month,
            Base.year,
            Base.era,
            Base.weekday,
            Base.weekdayOrdinal,
            Base.quarter,
            Base.weekOfMonth,
            Base.weekOfYear,
            Base.timeZone,
            Base.yearForWeekOfYear,
            Base.calendar
        ]

        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            components.append(Base.isLeapMonth)
        }

        return components
    }
    
    /// The component itself together with every finer grained component it contains.
    ///
    /// The result is ``includedComponents`` with the receiver appended, so it is ordered from the
    /// smallest unit to the receiver. For example `Calendar.Component.month.nz.allComponents`
    /// returns `[.nanosecond, .second, .minute, .hour, .day, .month]`.
    ///
    /// Components that contain nothing (`nanosecond`, `calendar`, `timeZone`) return a single
    /// element list holding only the receiver.
    var allComponents: [Calendar.Component] {
        includedComponents + [base]
    }
    
    /// Every finer grained component the receiver contains, without the receiver itself.
    ///
    /// Each component resolves to the full chain below it, walking down one step at a time:
    ///
    /// - `era` resolves to the chain of `year`.
    /// - `year` and `yearForWeekOfYear` resolve to the chain of `month`.
    /// - `quarter` resolves to the chain of `month`.
    /// - `month` resolves to the chain of `day`.
    /// - `weekOfYear` and `weekOfMonth` resolve to the chain of `weekday`.
    /// - `day`, `weekday` and `weekdayOrdinal` resolve to the chain of `hour`.
    /// - `hour` resolves to the chain of `minute`.
    /// - `minute` resolves to the chain of `second`.
    /// - `second` resolves to `[.nanosecond]`.
    /// - `nanosecond`, `calendar`, `timeZone` and any other component resolve to an empty list.
    ///
    /// Because the week chain goes through `weekday`, `Calendar.Component.weekOfYear.nz.includedComponents`
    /// returns `[.nanosecond, .second, .minute, .hour, .weekday]` and contains no `day` entry.
    var includedComponents: [Calendar.Component] {
        switch base {
        case .era:
            return Calendar.Component.year.nz.allComponents
            
        case .year, .yearForWeekOfYear:
            return Calendar.Component.month.nz.allComponents
            
        case .quarter:
            return Calendar.Component.month.nz.allComponents
            
        case .month:
            return Calendar.Component.day.nz.allComponents
            
        case .weekOfYear, .weekOfMonth:
            return Calendar.Component.weekday.nz.allComponents
            
        case .day, .weekday, .weekdayOrdinal:
            return Calendar.Component.hour.nz.allComponents
            
        case .hour:
            return Calendar.Component.minute.nz.allComponents
            
        case .minute:
            return Calendar.Component.second.nz.allComponents
            
        case .second:
            return Calendar.Component.nanosecond.nz.allComponents
            
        case .nanosecond:
            return []
            
        case .calendar, .timeZone:
            return []
            
        default:
            return []
        }
    }
}
