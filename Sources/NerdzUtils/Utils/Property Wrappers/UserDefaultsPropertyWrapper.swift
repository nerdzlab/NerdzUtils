//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

@propertyWrapper
public struct Defaults<T> {
    let key: String
    let initialValue: T

    public init(_ key: String, initial: T) {
        self.key = key
        self.initialValue = initial
    }

    public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? initialValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
