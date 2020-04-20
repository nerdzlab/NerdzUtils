//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

@propertyWrapper
struct Defaults<T> {
    let key: String
    let initialValue: T

    init(_ key: String, initial: T) {
        self.key = key
        self.initialValue = initial
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
