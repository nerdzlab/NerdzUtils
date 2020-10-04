//
//  Date+EasyUse.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import Foundation

public extension DateComponents {
    subscript(_ component: Calendar.Component) -> Int? {
        get {
            value(for: component)
        }
        
        set {
            setValue(newValue, for: component)
        }
    }
}

public extension Calendar.Component {
    
    static var allComponents: [Calendar.Component] {
        [
            nanosecond, 
            second, 
            minute,
            hour,
            day, 
            month, 
            year, 
            era, 
            weekday, 
            quarter, 
            weekOfMonth, 
            weekOfYear, 
            timeZone, 
            yearForWeekOfYear,
            timeZone,
            calendar
        ]
    }
    
    var allComponents: [Calendar.Component] {
        includedComponents + [self]
    }
    
    var includedComponents: [Calendar.Component] {
        switch self {
        case .era:
            return Calendar.Component.year.allComponents
            
        case .year, .yearForWeekOfYear:
            return Calendar.Component.month.allComponents
            
        case .quarter:
            return Calendar.Component.month.allComponents
            
        case .month:
            return Calendar.Component.day.allComponents
            
        case .weekOfYear, .weekOfMonth:
            return Calendar.Component.weekday.allComponents
            
        case .day, .weekday, .weekdayOrdinal:
            return Calendar.Component.hour.allComponents
            
        case .hour:
            return Calendar.Component.minute.allComponents
            
        case .minute:
            return Calendar.Component.second.allComponents
            
        case .second:
            return Calendar.Component.nanosecond.allComponents
            
        case .nanosecond:
            return []
            
        case .calendar, .timeZone:
            return []
            
        @unknown default:
            return []
        }
    }
}

public struct DateRange {
    let component: Calendar.Component
    let value: Int
    
    fileprivate func fill(into components: inout DateComponents) {
        components[component] = value
    }
    
    public static func second(_ value: Int) -> DateRange {
        DateRange(component: .second, value: value)
    }
    
    public static func minute(_ value: Int) -> DateRange {
        DateRange(component: .minute, value: value)
    }
    
    public static func hour(_ value: Int) -> DateRange {
        DateRange(component: .hour, value: value)
    }
    
    public static func day(_ value: Int) -> DateRange {
        DateRange(component: .day, value: value)
    }
    
    public static func month(_ value: Int) -> DateRange {
        DateRange(component: .month, value: value)
    }
    
    public static func year(_ value: Int) -> DateRange {
        DateRange(component: .year, value: value)
    }
}

public extension Date {
    static var now: Date {
        Date()
    }

    var allComponents: DateComponents {
        Calendar.current.dateComponents(Set(Calendar.Component.allComponents), from: self)
    }
    
    func isInSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: self)
    }
    
    func adding(_ range: DateRange) -> Date {        
        return Calendar.current.date(byAdding: range.component, value: range.value, to: self) ?? self
    }
    
    func start(of component: Calendar.Component) -> Date {
        var components = allComponents
        
        for innerComponent in component.includedComponents {
            components[innerComponent] = 0
        }
        
        return Calendar.current.date(from: components) ?? self
    }

    func end(of component: Calendar.Component) -> Date {
        start(of: component)
            .adding(DateRange(component: component, value: 1))
            .adding(.second(-1))
    }
}
