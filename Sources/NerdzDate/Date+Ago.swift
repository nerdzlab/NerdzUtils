//
//  Date+Ago.swift
//  NerdzUtils
//
//  Created by new user on 19.09.2020.
//

import Foundation
import NerdzCore

// Since IOS13 Apple introduce a new class RelativeDateTimeFormatter
// https://developer.apple.com/documentation/foundation/relativedatetimeformatter
// Use code below for IOS12 and lower

extension Date: NZExtensionCompatible { }

public extension NZExtensionData where Base == Date {
    func agoString(style: TimeAgoStyle) -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: base, to: .nz.now)
        
        if let years = interval.year, years > 0 {
            return TimeAgoComponent.year.text(for: years, style: style) + " ago"
        }
        else if let months = interval.month, months > 0 {
            return TimeAgoComponent.month.text(for: months, style: style) + " ago"
        }
        else if let days = interval.day, days > 0 {
            return TimeAgoComponent.day.text(for: days, style: style) + " ago"
        }
        else if let hours = interval.hour, hours > 0 {
            return TimeAgoComponent.hour.text(for: hours, style: style) + " ago"
        }
        else if let minutes = interval.minute, minutes > 0 {
            return TimeAgoComponent.minute.text(for: minutes, style: style) + " ago"
        }
        else if let seconds = interval.second, seconds > 0 {
            return TimeAgoComponent.second.text(for: seconds, style: style) + " ago"
        }
        else {
            return "Just now"
        }
    }
}

public enum TimeAgoStyle {
    case short, full
    
    func suffix(for component: TimeAgoComponent, isPlural: Bool) -> String {
        switch component {
        case .second: return (self == .short ? "s" : (isPlural ? "seconds" : "second"))
        case .minute: return (self == .short ? "m" : (isPlural ? "minutes" : "minute"))
        case .hour: return (self == .short ? "h" : (isPlural ? "hours" : "hour"))
        case .day: return (self == .short ? "d" : (isPlural ? "days" : "day"))
        case .month: return (self == .short ? "mo" : (isPlural ? "months" : "month"))
        case .year: return (self == .short ? "y" : (isPlural ? "years" : "year"))
        }
    }
}

public enum TimeAgoComponent {
    case second, minute, hour, day, month, year
    
    func text(for value: Int, style: TimeAgoStyle) -> String {
        let suffix: String = style.suffix(for: self, isPlural: value != 1)
        return "\(value) \(suffix)"
    }
}
