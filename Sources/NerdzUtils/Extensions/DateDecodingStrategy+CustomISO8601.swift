//
//  File.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation

public extension JSONDecoder.DateDecodingStrategy {
    
    /// Return formate for time with fractal seconds
    @available(iOS 11.0, macOS 10.13, *)
    static let customISO8601: JSONDecoder.DateDecodingStrategy = custom { decoder throws -> Date in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = Formatter.iso8601WithFS.date(from: string) ?? Formatter.iso8601.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}
