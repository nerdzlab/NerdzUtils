//
//  File.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation
import NerdzCore

extension JSONDecoder.DateDecodingStrategy: NZExtensionCompatible { }

public extension NZExtensionData where Base == JSONDecoder.DateDecodingStrategy {

    /// A decoding strategy that accepts ISO8601 timestamps with or without fractional seconds.
    ///
    /// The strategy decodes a single `String` value and tries ``iso8601WithFS`` first, so
    /// `2020-09-28T10:15:30.123Z` is read directly. When that formatter returns no date, it falls
    /// back to ``iso8601`` and reads `2020-09-28T10:15:30Z`. This makes it safe against backends
    /// that only send milliseconds on some fields.
    ///
    /// ```swift
    /// let decoder = JSONDecoder()
    /// decoder.dateDecodingStrategy = .nz.customISO8601
    /// ```
    ///
    /// A value that neither formatter can parse raises
    /// `DecodingError.dataCorrupted`, carrying the offending string in its debug description.
    @available(iOS 11.0, macOS 10.13, *)
    static let customISO8601: JSONDecoder.DateDecodingStrategy = JSONDecoder.DateDecodingStrategy.custom { decoder throws -> Date in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = Formatter.nz.iso8601WithFS.date(from: string) ?? Formatter.nz.iso8601.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}
