//
//  DateRange.swift
//  NerdzDate
//
//  Created by new user on 07.10.2020.
//

import Foundation
import NerdzCore

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
    
    public static func weekOfYear(_ value: Int) -> DateRange {
        DateRange(component: .weekOfYear, value: value)
    }
    
    public static func weekOfMonth(_ value: Int) -> DateRange {
        DateRange(component: .weekOfMonth, value: value)
    }
    
    public static func month(_ value: Int) -> DateRange {
        DateRange(component: .month, value: value)
    }
    
    public static func year(_ value: Int) -> DateRange {
        DateRange(component: .year, value: value)
    }
}
