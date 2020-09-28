//
//  File.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation

public extension Formatter {
    
    ///
    /// Return iso8601 formatter
    ///
    @available(iOS 11.0, *)
    static let iso8601noFS = ISO8601DateFormatter()
    
    @available(iOS 11.0, *)
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
