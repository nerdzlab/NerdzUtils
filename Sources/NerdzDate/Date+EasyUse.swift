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
        var components = allComponents
        
        for innerComponent in component.nz.includedComponents {
            components[innerComponent] = 0
        }
        
        var result = Calendar.current.date(from: components) ?? base
        
        // Strange fix for weeks
        if let weekday = base[.weekday], component == .weekOfMonth || component == .weekOfYear {
            result = result.nz.adding(.day(-weekday + 1))
        }
        
        return result
    }

    func end(of component: Calendar.Component) -> Date {
        start(of: component)
            .nz.adding(DateRange(component: component, value: 1))
            .nz.adding(.second(-1))
    }
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
