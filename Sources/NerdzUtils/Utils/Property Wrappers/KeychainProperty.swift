//
//  KeychainProperty.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation
import KeychainAccess

@propertyWrapper
@available(iOS 11.0, *)
public struct KeychainProperty<Type: Codable> {
    let key: String
    let initialValue: Type
    let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")

    public init(_ key: String, initial: Type) {
        self.key = key
        self.initialValue = initial
    }

    public var wrappedValue: Type {
        get {
            var returnValue: Type?
            do {
                returnValue = try keychain.getData(key)?.object(of: Type.self)
            }
            catch {
                print("Error retriving data from keychain")
            }
            return returnValue ?? initialValue
        }
        set {
            guard let data = newValue.jsonData else { return }
            try? keychain.set(data, key: key)
        }
    }
}
