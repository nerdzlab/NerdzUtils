//
//  Date+Ago.swift
//  NerdzUtils
//
//  Created by new user on 19.09.2020.
//

import Foundation

public extension Date {
    var agoString: String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: .now)
        
        if let years = interval.year, years > 0 {
            return "\(years)y"
        } 
        else if let months = interval.month, months > 0 {
            return "\(months)mo"
        } 
        else if let days = interval.day, days > 0 {
            return "\(days)d"
        } 
        else if let hours = interval.hour, hours > 0 {
            return "\(hours)h"
        } 
        else if let minutes = interval.minute, minutes > 0 {
            return "\(minutes)m"
        } 
        else if let seconds = interval.second, seconds > 0 {
            return "\(seconds)s"
        } 
        else {
            return "Now"
        }
    }
}
