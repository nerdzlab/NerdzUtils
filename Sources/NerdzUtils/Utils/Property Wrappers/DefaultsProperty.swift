//
//  DefaultsProperty.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

/// A property wrapper that automatically syncing property into user defaults
@available(iOS 11.0, macOS 10.12, *) 
@propertyWrapper public struct DefaultsProperty<Type: Codable> {
    let key: String
    let initialValue: Type
    let defaults = UserDefaults.standard
    
    /// Initialize property
    /// - Parameters:
    ///   - key: Defaults storing key
    ///   - initial: Initial value for case when defaults value empty
    public init(_ key: String, initial: Type) {
        self.key = key
        self.initialValue = initial
    }
    
    /// Wrapped value
    public var wrappedValue: Type {
        get {
            return (try? defaults.data(forKey: key)?.object(of: Type.self)) ?? initialValue
        }
        set {
            guard let data = newValue.jsonData else {
                defaults.removeObject(forKey: key)
                return
            }
            defaults.setValue(data, forKey: key)
        }
    }
}
