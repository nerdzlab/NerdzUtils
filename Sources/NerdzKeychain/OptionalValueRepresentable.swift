//
//  OptionalValueRepresentable.swift
//
//
//  Created by Roman Kovalchuk on 22.09.2026.
//

import Foundation

/// A type that can represent an absent value
protocol OptionalValueRepresentable {
    /// Indicates that the value is absent
    var isNil: Bool { get }
}

extension Optional: OptionalValueRepresentable {
    var isNil: Bool {
        self == nil
    }
}
