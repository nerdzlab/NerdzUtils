//
//  File.swift
//  
//
//  Created by Mykhailo on 06.04.2021.
//

import Foundation
import NerdzCore

public extension NZExtensionData where Base == Date {
    enum Weekday: Int {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    }
    
    func next(
        _ weekday: Weekday,
        considerToday: Bool = false
    ) -> Date? {
        findWeekDayDate(weekday, direction: .forward, considerToday: considerToday)
    }
    
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
