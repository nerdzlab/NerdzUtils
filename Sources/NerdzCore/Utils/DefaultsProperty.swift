//
//  DefaultsProperty.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

/// A property wrapper that stores a `Codable` value in `UserDefaults`.
///
/// Reading the property decodes the stored JSON, and writing it encodes the new value and stores
/// it. A value that cannot be encoded removes the stored entry instead, so the property falls back
/// to its initial value.
///
/// ```swift
/// @DefaultsProperty("user.didOnboard", initial: false)
/// var didOnboard: Bool
/// ```
///
/// - Important: Values are encoded as JSON with the ISO8601 date strategy, so `Date` values are
///   stored with second precision and lose their sub second part on a round trip.
@available(iOS 11.0, macOS 10.12, *) 
@propertyWrapper public struct DefaultsProperty<Type: Codable> {
    let key: String
    let initialValue: Type
    let defaults: UserDefaults
    
    /// Creates a property backed by the given defaults key.
    ///
    /// - Parameters:
    ///   - key: The `UserDefaults` key the value is stored under.
    ///   - initial: The value returned while nothing valid is stored under `key`.
    ///   - defaults: The defaults database to read from and write to. Defaults to
    ///     `UserDefaults.standard`.
    public init(_ key: String, initial: Type, defaults: UserDefaults = .standard) {
        self.key = key
        self.initialValue = initial
        self.defaults = defaults
    }
    
    /// The stored value.
    ///
    /// Reading returns the decoded stored value, or the initial value when the key holds nothing or
    /// holds data that does not decode into `Type`. Writing stores the encoded value, or removes
    /// the key when the value cannot be encoded.
    public var wrappedValue: Type {
        get {
            return (try? defaults.data(forKey: key)?.nz.object(of: Type.self)) ?? initialValue
        }
        set {
            guard let data = newValue.nz_jsonData else {
                defaults.removeObject(forKey: key)
                return
            }
            
            defaults.set(data, forKey: key)
        }
    }
}
