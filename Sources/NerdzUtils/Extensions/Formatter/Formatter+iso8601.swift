//
//  File.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation

public extension NZUtilsExtensionData where Base: Formatter {
    /// Return iso8601 with fractional seconds
    @available(iOS 11.0, macOS 10.13, *)
    static var iso8601WithFS: ISO8601DateFormatter {
        Formatter.iso8601WithFS
    }
    
    /// Return iso8601
    @available(iOS 11.0, macOS 10.13, *)
    static var iso8601: ISO8601DateFormatter {
        Formatter.iso8601
    }
}

private extension Formatter {
    
    /// Return iso8601 with fractional seconds
    @available(iOS 11.0, macOS 10.13, *) 
    static let iso8601WithFS: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    /// Return iso8601
    @available(iOS 11.0, macOS 10.13, *) 
    static let iso8601: ISO8601DateFormatter = ISO8601DateFormatter()
}
