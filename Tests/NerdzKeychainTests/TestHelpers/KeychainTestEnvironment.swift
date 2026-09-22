//
//  KeychainTestEnvironment.swift
//
//
//  Created by Roman Kovalchuk on 22.09.2026.
//

import Foundation
import Testing
import KeychainAccess

enum KeychainTestEnvironment {
    static let servicePrefix = "com.nerdz.nerdzutils.tests.keychain"

    static let unavailableReason: Comment = "Keychain is not accessible from this test binary"

    static let isKeychainAccessible: Bool = {
        let keychain = makeIsolatedKeychain()
        defer { try? keychain.removeAll() }

        let probeKey = "availability.probe"
        let probeValue = Data([0xA1, 0xB2])

        do {
            try keychain.set(probeValue, key: probeKey)
            return try keychain.getData(probeKey) == probeValue
        }
        catch {
            return false
        }
    }()

    static func makeIsolatedKeychain() -> Keychain {
        Keychain(service: "\(servicePrefix).\(UUID().uuidString)")
    }
}
