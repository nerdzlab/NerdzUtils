//
//  KeychainProperty.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation
import KeychainAccess

/// A property wrapper that automatically syncing property into keychain
@available(iOS 11.0, macOS 10.12, *) 
@propertyWrapper public struct KeychainProperty<Type: Codable> {
    let key: String
    let initialValue: Type
    let keychain: Keychain

    /// Initialize property
    /// - Parameters:
    ///   - key: Keychain storing key
    ///   - initial: Initial value for case when keychain value empty
    public init(_ key: String, initial: Type, keychain: Keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")) {
        self.key = key
        self.initialValue = initial
        self.keychain = keychain
    }
    
    /// Wrapped value
    public var wrappedValue: Type {
        get {
            var returnValue: Type?
            do {
                returnValue = try keychain.getData(key)?.nz.object(of: Type.self)
            }
            catch {
                print("Error retriving data from keychain")
            }
            return returnValue ?? initialValue
        }
        set {
            guard let data = newValue.nz_jsonData else {
                try? keychain.remove(key)
                return
            }
            
            try? keychain.set(data, key: key)
        }
    }
}
