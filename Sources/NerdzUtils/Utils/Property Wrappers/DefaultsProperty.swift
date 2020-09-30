//
//  DefaultsProperty.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

@propertyWrapper
@available(iOS 11.0, *)
public struct DefaultsProperty<Type: Codable> {
    let key: String
    let initialValue: Type
    let defaults = UserDefaults.standard

    public init(_ key: String, initial: Type) {
        self.key = key
        self.initialValue = initial
    }

    public var wrappedValue: Type {
        get {
            return (try? defaults.data(forKey: key)?.object(of: Type.self)) ?? initialValue
        }
        set {
            guard let data = newValue.jsonData else { return }
            defaults.setValue(data, forKey: key)
        }
    }
}
