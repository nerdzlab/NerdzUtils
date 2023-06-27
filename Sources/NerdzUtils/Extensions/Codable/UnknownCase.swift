//
//  UnknownCase.swift
//  
//
//  Created by Roman Kovalchuk on 27.06.2023.
//

import Foundation

public protocol UnknownCase: RawRepresentable, CaseIterable where RawValue: Equatable & Codable {
    static var unknownCase: Self { get }
}

public extension UnknownCase {
    init(rawValue: RawValue) {
        let value = Self.allCases.first { $0.rawValue == rawValue }
        self = value ?? Self.unknownCase
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValue.self)
        let value = Self(rawValue: rawValue)
        self = value ?? Self.unknownCase
    }
}
