//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation
import NerdzCore

public extension NZExtensionData where Base == Date {
    var global: Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: base))
        return Date(timeInterval: seconds, since: base)
    }
    
    var local: Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: base))
        return Date(timeInterval: seconds, since: base)
    }
}
