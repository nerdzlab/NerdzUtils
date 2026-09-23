//
//  UnknownCase.swift
//  
//
//  Created by Roman Kovalchuk on 27.06.2023.
//

import Foundation

/// An enumeration that falls back to a dedicated case instead of failing on an unknown raw value.
///
/// Conform a `Codable` enumeration to this protocol to keep decoding alive when a backend starts
/// sending a value the app does not know yet. The only requirement to implement is
/// ``unknownCase``, because the protocol supplies both the raw value initializer and the
/// `Decodable` initializer.
///
/// ```swift
/// enum Status: String, UnknownCase {
///     case active
///     case blocked
///     case unknown
///
///     static var unknownCase: Status { .unknown }
/// }
///
/// Status(rawValue: "deleted")  // .unknown
/// ```
public protocol UnknownCase: RawRepresentable, CaseIterable where RawValue: Equatable & Codable {
    /// The case returned for any raw value that no other case matches.
    static var unknownCase: Self { get }
}

public extension UnknownCase {
    /// Creates a case from a raw value, falling back to ``unknownCase``.
    ///
    /// Unlike the synthesized initializer of a `RawRepresentable` enumeration, this one never
    /// returns `nil`, because an unmatched raw value produces ``unknownCase``.
    ///
    /// - Parameter rawValue: The raw value to look up among `allCases`.
    init(rawValue: RawValue) {
        let value = Self.allCases.first { $0.rawValue == rawValue }
        self = value ?? Self.unknownCase
    }
    
    /// Creates a case by decoding its raw value, falling back to ``unknownCase``.
    ///
    /// The raw value is read from a single value container, so the enumeration decodes from a bare
    /// JSON value such as a string or a number. A raw value that matches no case decodes as
    /// ``unknownCase`` rather than throwing.
    ///
    /// - Parameter decoder: The decoder to read the raw value from.
    /// - Throws: A `DecodingError` when the container does not hold a value of the raw value type.
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValue.self)
        let value = Self(rawValue: rawValue)
        self = value ?? Self.unknownCase
    }
}
