//
//  Date+EasyUse.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import Foundation

extension Date {
    static var now: Date {
        Date()
    }
    
    var dayStart: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var dayEnd: Date {
        dayStart.adding(days: 1, seconds: -1)
    }
    
    func isInSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: self)
    }
    
    func adding(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var components = DateComponents()
        
        components.year = years
        components.month = months
        components.day = days
        components.hour = hours
        components.minute = minutes
        components.second = seconds
        
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }
}
