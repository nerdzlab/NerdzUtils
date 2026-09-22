//
//  KeychainPropertyError.swift
//
//
//  Created by Roman Kovalchuk on 22.09.2026.
//

import Foundation

/// A failure happened while a ``KeychainProperty`` was reading or writing its value
public struct KeychainPropertyError: Error {

    /// The operation that failed
    public enum Operation: Sendable {
        /// Loading the stored value failed, the initial value is used instead
        case read

        /// Storing or removing the value failed, the keychain still holds the previous state
        case write

        /// Encoding the value into its stored representation failed, the stored item is removed
        case encode
    }

    /// The operation that failed
    public let operation: Operation

    /// The keychain key the failed operation was performed on
    public let key: String

    /// The error thrown by the underlying keychain or coding machinery, if there is one
    public let underlyingError: Error?

    init(operation: Operation, key: String, underlyingError: Error? = nil) {
        self.operation = operation
        self.key = key
        self.underlyingError = underlyingError
    }
}

/// A closure receiving every failure reported by a ``KeychainProperty``
public typealias KeychainPropertyErrorHandler = (KeychainPropertyError) -> Void
