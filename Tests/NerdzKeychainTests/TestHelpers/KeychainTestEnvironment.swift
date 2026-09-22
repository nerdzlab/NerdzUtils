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

    static let writeFailureUnavailableReason: Comment = "Keychain writes can not be made to fail from this test binary"

    static let probeKey = "availability.probe"
    static let probeValue = Data([0xA1, 0xB2])

    static let isKeychainAccessible: Bool = {
        let keychain = makeIsolatedKeychain()
        defer { try? keychain.removeAll() }

        do {
            try keychain.set(probeValue, key: probeKey)
            return try keychain.getData(probeKey) == probeValue
        }
        catch {
            return false
        }
    }()

    static let isWriteFailureSimulatable: Bool = {
        let keychain = makeWriteFailingKeychain()
        defer { try? keychain.removeAll() }

        do {
            try keychain.set(probeValue, key: probeKey)
            return false
        }
        catch {
            return true
        }
    }()

    static func makeIsolatedKeychain() -> Keychain {
        Keychain(service: "\(servicePrefix).\(UUID().uuidString)")
    }

    static func makeWriteFailingKeychain() -> Keychain {
        makeIsolatedKeychain().synchronizable(true)
    }
}
