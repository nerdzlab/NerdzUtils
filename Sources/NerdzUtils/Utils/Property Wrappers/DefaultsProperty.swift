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
    let defaults: UserDefaults
    
    /// Initialize property
    /// - Parameters:
    ///   - key: Defaults storing key
    ///   - initial: Initial value for case when defaults value empty
    public init(_ key: String, initial: Type, defaults: UserDefaults = .standard) {
        self.key = key
        self.initialValue = initial
        self.defaults = defaults
    }
    
    /// Wrapped value
    public var wrappedValue: Type {
        get {
            return (try? defaults.data(forKey: key)?.nz.object(of: Type.self)) ?? initialValue
        }
        set {
            guard let data = newValue.nz_jsonData else {
                defaults.removeObject(forKey: key)
                return
            }
            
            defaults.setValue(data, forKey: key)
        }
    }
}
