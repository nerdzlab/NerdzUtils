//
//  KeychainProperty.swift
//
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation
import NerdzCore
import KeychainAccess

/// A property wrapper that automatically syncing property into keychain
///
/// Assigning `nil` to a property with an `Optional` value type removes the stored keychain item,
/// after which the property reports its initial value again.
///
/// Values are stored in their JSON representation with the ISO8601 date format, which has a resolution
/// of one second. A `Date` carrying fractional seconds is truncated to a whole second by a store and load
/// round trip.
///
/// Reading and writing failures never stop the property from returning a value. They are reported to the
/// error handler passed into the initializer, so the caller can log or escalate them.
@available(iOS 11.0, macOS 10.12, *)
@propertyWrapper public struct KeychainProperty<Type: Codable> {
    let key: String
    let initialValue: Type
    let keychain: Keychain
    let errorHandler: KeychainPropertyErrorHandler

    /// Initialize property
    /// - Parameters:
    ///   - key: Keychain storing key
    ///   - initial: Initial value for case when keychain value empty
    ///   - keychain: Keychain instance
    ///   - errorHandler: Closure called with every reading or writing failure
    public init(
        _ key: String,
        initial: Type,
        keychain: Keychain = Keychain(service: Bundle.main.bundleIdentifier ?? ""),
        onError errorHandler: @escaping KeychainPropertyErrorHandler = { _ in }
    ) {
        self.key = key
        self.initialValue = initial
        self.keychain = keychain
        self.errorHandler = errorHandler
    }

    /// Wrapped value
    public var wrappedValue: Type {
        get {
            do {
                let storedValue = try keychain.getData(key)?.nz.object(of: Type.self)
                return storedValue ?? initialValue
            }
            catch {
                errorHandler(KeychainPropertyError(operation: .read, key: key, underlyingError: error))
                return initialValue
            }
        }
        set {
            do {
                guard !isNil(newValue) else {
                    try keychain.remove(key)
                    return
                }

                guard let data = newValue.nz_jsonData else {
                    try keychain.remove(key)
                    errorHandler(KeychainPropertyError(operation: .encode, key: key))
                    return
                }

                try keychain.set(data, key: key)
            }
            catch {
                errorHandler(KeychainPropertyError(operation: .write, key: key, underlyingError: error))
            }
        }
    }

    private func isNil(_ value: Type) -> Bool {
        (value as? OptionalValueRepresentable)?.isNil ?? false
    }
}
