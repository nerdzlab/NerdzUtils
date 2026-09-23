//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation
import NerdzCore

public extension NZExtensionData where Base == Date {

    /// The date moved back by the current time zone's offset from GMT.
    ///
    /// The offset is `TimeZone.current.secondsFromGMT(for:)` evaluated for the date itself, so
    /// daylight saving is taken into account. Formatting the result in the current time zone gives
    /// the same wall clock reading that formatting the original date in GMT gives.
    ///
    /// ``local`` performs the opposite shift. The two are exact inverses whenever both instants
    /// fall inside the same daylight saving period.
    var global: Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: base))
        return Date(timeInterval: seconds, since: base)
    }
    
    /// The date moved forward by the current time zone's offset from GMT.
    ///
    /// The offset is `TimeZone.current.secondsFromGMT(for:)` evaluated for the date itself, so
    /// daylight saving is taken into account. Formatting the result in GMT gives the same wall
    /// clock reading that formatting the original date in the current time zone gives.
    ///
    /// ``global`` performs the opposite shift.
    var local: Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: base))
        return Date(timeInterval: seconds, since: base)
    }
}
