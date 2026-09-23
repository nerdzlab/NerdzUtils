//
//  File.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation
import NerdzCore

public extension NZExtensionData where Base: Formatter {

    /// A shared ISO8601 formatter that keeps fractional seconds.
    ///
    /// The format options are `[.withInternetDateTime, .withFractionalSeconds]`, so the formatter
    /// reads and writes values such as `2020-09-28T10:15:30.123Z`. The instance is created once
    /// and reused, so do not change its `formatOptions` or `timeZone`.
    ///
    /// ``customISO8601`` tries this formatter first when decoding.
    @available(iOS 11.0, macOS 10.13, *)
    static var iso8601WithFS: ISO8601DateFormatter {
        Formatter.iso8601WithFS
    }
    
    /// A shared ISO8601 formatter with the default options.
    ///
    /// `ISO8601DateFormatter` defaults to `.withInternetDateTime`, so the formatter reads and
    /// writes values such as `2020-09-28T10:15:30Z` and rejects fractional seconds. The instance
    /// is created once and reused, so do not change its `formatOptions` or `timeZone`.
    ///
    /// Use ``iso8601WithFS`` when the payload carries milliseconds.
    @available(iOS 11.0, macOS 10.13, *)
    static var iso8601: ISO8601DateFormatter {
        Formatter.iso8601
    }
}

private extension Formatter {
    
    /// Return iso8601 with fractional seconds
    @available(iOS 11.0, macOS 10.13, *)
    nonisolated(unsafe) static let iso8601WithFS: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    /// Return iso8601
    @available(iOS 11.0, macOS 10.13, *)
    nonisolated(unsafe) static let iso8601: ISO8601DateFormatter = ISO8601DateFormatter()
}
