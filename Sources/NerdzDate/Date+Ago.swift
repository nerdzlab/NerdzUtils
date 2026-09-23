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

    /// Describes how long ago the date was, relative to the current moment.
    ///
    /// The difference between the date and now is measured with `Calendar.current` in years,
    /// months, days, hours, minutes and seconds. The largest unit with a value above zero wins,
    /// and the result is that value, a suffix taken from ``TimeAgoStyle``, and the word `ago`,
    /// for example `3 d ago` or `3 days ago`.
    ///
    /// When no unit is above zero the result is `Just now`. That covers the current second and
    /// every date in the future, because a future date produces negative components.
    ///
    /// The wording is fixed English and is not localized. On iOS 13 and newer, `RelativeDateTimeFormatter`
    /// is the localized alternative.
    ///
    /// - Parameter style: Whether the unit is abbreviated (``TimeAgoStyle/short``) or spelled out
    ///   (``TimeAgoStyle/full``).
    /// - Returns: A phrase such as `5 m ago`, `1 month ago` or `Just now`.
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

/// The wording used by `Date.nz.agoString(style:)`.
public enum TimeAgoStyle {
    /// Abbreviated units: `s`, `m`, `h`, `d`, `mo`, `y`.
    case short

    /// Spelled out units that agree in number, such as `second`, `seconds`, `month`, `months`.
    case full
    
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

/// The units `Date.nz.agoString(style:)` can report.
///
/// The units are ordered from the smallest to the largest. Weeks are deliberately absent, so a
/// ten day old date reads as `10 days ago` rather than as a number of weeks.
public enum TimeAgoComponent {
    /// A number of seconds.
    case second

    /// A number of minutes.
    case minute

    /// A number of hours.
    case hour

    /// A number of days.
    case day

    /// A number of months.
    case month

    /// A number of years.
    case year
    
    func text(for value: Int, style: TimeAgoStyle) -> String {
        let suffix: String = style.suffix(for: self, isPlural: value != 1)
        return "\(value) \(suffix)"
    }
}
