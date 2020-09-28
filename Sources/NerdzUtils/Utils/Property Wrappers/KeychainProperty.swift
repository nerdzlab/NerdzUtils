//
//  KeychainProperty.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation
import KeychainAccess

@available(iOS 11.0, *)
@propertyWrapper
struct KeychainProperty<Type: Codable> {
    let key: String
    let initialValue: Type
    let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")

    init(_ key: String, initial: Type) {
        self.key = key
        self.initialValue = initial
    }

    var wrappedValue: Type {
        get {
            var returnValue: Type?
            do {
                returnValue = try keychain.getData(key)?.getObject(of: Type.self)
            }
            catch {
                NSLog("Error retriving data from keychain")
            }
            return returnValue ?? initialValue
        }
        set {
            guard let data = newValue.jsonData else { return }
            try? keychain.set(data, key: key)
        }
    }
}
