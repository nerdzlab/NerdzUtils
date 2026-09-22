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
    
    static var allComponents: [Calendar.Component] {
        [
            Base.nanosecond,
            Base.second,
            Base.minute,
            Base.hour,
            Base.day,
            Base.month,
            Base.year,
            Base.era,
            Base.weekday,
            Base.quarter,
            Base.weekOfMonth,
            Base.weekOfYear,
            Base.timeZone,
            Base.yearForWeekOfYear,
            Base.timeZone,
            Base.calendar
        ]
    }
    
    var allComponents: [Calendar.Component] {
        includedComponents + [base]
    }
    
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
            
        @unknown default:
            return []
        }
    }
}
