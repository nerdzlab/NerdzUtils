//
//  Date+EasyUse.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import Foundation

public enum DateUnit {
    case second(_ value: Int)
    case minute(_ value: Int)
    case hour(_ value: Int)
    case day(_ value: Int)
    case month(_ value: Int)
    case year(_ value: Int)
    
    fileprivate func fill(into components: inout DateComponents) {
        switch self {
        case .second(let value): components.second = value
        case .minute(let value): components.minute = value
        case .hour(let value): components.hour = value
        case .day(let value): components.day = value
        case .month(let value): components.month = value
        case .year(let value): components.year = value
        }
    }
}

public extension Date {
    static var now: Date {
        Date()
    }
    
    var dayStart: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var dayEnd: Date {
        dayStart.adding(.day(1), .second(-1))
    }
    
    func isInSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: self)
    }
    
    func adding(_ units: DateUnit...) -> Date {
        var components = DateComponents()
        
        for unit in units {
            unit.fill(into: &components)
        }
        
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }
    
    func next(_ unit: DateUnit) -> Date {
        var components = DateComponents()
        unit.fill(into: &components)
        
        return Calendar.current.nextDate(after: self, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents) ?? self
    }
}
