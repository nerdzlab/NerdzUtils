//
//  KeychainPropertyTests.swift
//
//
//  Created by Roman Kovalchuk on 22.09.2026.
//

import Foundation
import Testing
import KeychainAccess
@testable import NerdzKeychain

@Suite(
    "Keychain Property Tests",
    .enabled(if: KeychainTestEnvironment.isKeychainAccessible, KeychainTestEnvironment.unavailableReason)
)
struct KeychainPropertyTests {

    @Suite("Initial Value")
    struct InitialValue {

        @Test
        func testWhenNothingStoredShouldReturnInitialValue() {
            // Arrange
            let initialValue = TestData.initialToken
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            let property = TestData.createTokenProperty(initial: initialValue, keychain: keychain)

            // Act
            let result = property.wrappedValue

            // Assert
            #expect(result == initialValue)
        }

        @Test
        func testWhenStoredItemRemovedShouldReturnInitialValue() throws {
            // Arrange
            let initialValue = TestData.initialToken
            let key = TestData.tokenKey
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var property = TestData.createTokenProperty(key: key, initial: initialValue, keychain: keychain)
            property.wrappedValue = TestData.storedToken

            // Act
            try keychain.remove(key)

            // Assert
            #expect(property.wrappedValue == initialValue)
        }

        @Test
        func testWhenStoredDataIsCorruptedShouldReturnInitialValue() throws {
            // Arrange
            let initialValue = TestData.initialToken
            let key = TestData.tokenKey
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            let property = TestData.createTokenProperty(key: key, initial: initialValue, keychain: keychain)

            // Act
            try keychain.set(TestData.corruptedPayload, key: key)

            // Assert
            #expect(property.wrappedValue == initialValue)
        }
    }

    @Suite("Value Round Trip")
    struct ValueRoundTrip {

        @Test
        func testWhenValueStoredShouldReturnSameValue() {
            // Arrange
            let storedValue = TestData.storedToken
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var property = TestData.createTokenProperty(keychain: keychain)

            // Act
            property.wrappedValue = storedValue

            // Assert
            #expect(property.wrappedValue == storedValue)
        }

        @Test
        func testWhenValueStoredShouldBeVisibleToAnotherPropertyInstance() {
            // Arrange
            let storedValue = TestData.storedToken
            let key = TestData.tokenKey
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var writingProperty = TestData.createTokenProperty(key: key, keychain: keychain)
            let readingProperty = TestData.createTokenProperty(key: key, keychain: keychain)

            // Act
            writingProperty.wrappedValue = storedValue

            // Assert
            #expect(readingProperty.wrappedValue == storedValue)
        }

        @Test
        func testWhenValueOverwrittenShouldReturnLatestValue() {
            // Arrange
            let latestValue = TestData.updatedToken
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var property = TestData.createTokenProperty(keychain: keychain)
            property.wrappedValue = TestData.storedToken

            // Act
            property.wrappedValue = latestValue

            // Assert
            #expect(property.wrappedValue == latestValue)
        }

        @Test
        func testWhenDifferentKeysUsedShouldStoreValuesIndependently() {
            // Arrange
            let firstValue = TestData.storedToken
            let secondValue = TestData.updatedToken
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var firstProperty = TestData.createTokenProperty(key: TestData.tokenKey, keychain: keychain)
            var secondProperty = TestData.createTokenProperty(key: TestData.secondaryKey, keychain: keychain)

            // Act
            firstProperty.wrappedValue = firstValue
            secondProperty.wrappedValue = secondValue

            // Assert
            #expect(firstProperty.wrappedValue == firstValue)
            #expect(secondProperty.wrappedValue == secondValue)
        }

        @Test(arguments: TestData.tokenVariants)
        func testWhenTokenVariantStoredShouldReturnSameValue(storedValue: String) {
            // Arrange
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var property = TestData.createTokenProperty(keychain: keychain)

            // Act
            property.wrappedValue = storedValue

            // Assert
            #expect(property.wrappedValue == storedValue)
        }
    }

    @Suite("Optional Values")
    struct OptionalValues {

        @Test
        func testWhenOptionalValueStoredShouldReturnSameValue() {
            // Arrange
            let storedValue = TestData.storedToken
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var property = TestData.createOptionalTokenProperty(keychain: keychain)

            // Act
            property.wrappedValue = storedValue

            // Assert
            #expect(property.wrappedValue == storedValue)
        }

        @Test
        func testWhenOptionalValueSetToNilShouldReturnNil() {
            // Arrange
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var property = TestData.createOptionalTokenProperty(initial: TestData.initialToken, keychain: keychain)
            property.wrappedValue = TestData.storedToken

            // Act
            property.wrappedValue = nil

            // Assert
            #expect(property.wrappedValue == nil)
        }

        @Test
        func testWhenOptionalValueSetToNilShouldKeepStoredItem() throws {
            // Arrange
            let key = TestData.tokenKey
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var property = TestData.createOptionalTokenProperty(key: key, keychain: keychain)
            property.wrappedValue = TestData.storedToken

            // Act
            property.wrappedValue = nil

            // Assert
            #expect(try keychain.getData(key) != nil)
        }

        @Test
        func testWhenNothingStoredForOptionalShouldReturnInitialValue() throws {
            // Arrange
            let initialValue = TestData.initialToken
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            let property = TestData.createOptionalTokenProperty(initial: initialValue, keychain: keychain)

            // Act
            let result = try #require(property.wrappedValue)

            // Assert
            #expect(result == initialValue)
        }
    }

    @Suite("Non Encodable Values")
    struct NonEncodableValues {

        @Test
        func testWhenValueCanNotBeEncodedShouldRemoveStoredItem() throws {
            // Arrange
            let key = TestData.measurementKey
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var property = TestData.createMeasurementProperty(key: key, keychain: keychain)
            property.wrappedValue = TestData.storedMeasurement

            // Act
            property.wrappedValue = TestData.nonEncodableMeasurement

            // Assert
            #expect(try keychain.getData(key) == nil)
        }

        @Test
        func testWhenValueCanNotBeEncodedShouldReturnInitialValue() {
            // Arrange
            let initialValue = TestData.initialMeasurement
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var property = TestData.createMeasurementProperty(initial: initialValue, keychain: keychain)
            property.wrappedValue = TestData.storedMeasurement

            // Act
            property.wrappedValue = TestData.nonEncodableMeasurement

            // Assert
            #expect(property.wrappedValue == initialValue)
        }
    }

    @Suite("Codable Round Trip")
    struct CodableRoundTrip {

        @Test
        func testWhenCodableValueStoredShouldReturnEqualValue() {
            // Arrange
            let storedValue = TestData.createCredentials()
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var property = TestData.createCredentialsProperty(keychain: keychain)

            // Act
            property.wrappedValue = storedValue

            // Assert
            #expect(property.wrappedValue == storedValue)
        }

        @Test
        func testWhenCodableValueStoredShouldPreserveDate() {
            // Arrange
            let issueDate = TestData.fixedDate
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var property = TestData.createCredentialsProperty(keychain: keychain)

            // Act
            property.wrappedValue = TestData.createCredentials(issuedAt: issueDate)

            // Assert
            #expect(property.wrappedValue.issuedAt == issueDate)
        }

        @Test
        func testWhenCodableCollectionStoredShouldReturnEqualValues() {
            // Arrange
            let storedValues = [TestData.createCredentials(token: TestData.storedToken), TestData.createCredentials(token: TestData.updatedToken)]
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var property = TestData.createCredentialsListProperty(keychain: keychain)

            // Act
            property.wrappedValue = storedValues

            // Assert
            #expect(property.wrappedValue == storedValues)
        }

        @Test
        func testWhenCodableValueOverwrittenShouldReturnLatestValue() {
            // Arrange
            let latestValue = TestData.createCredentials(token: TestData.updatedToken, refreshCount: TestData.updatedRefreshCount)
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var property = TestData.createCredentialsProperty(keychain: keychain)
            property.wrappedValue = TestData.createCredentials()

            // Act
            property.wrappedValue = latestValue

            // Assert
            #expect(property.wrappedValue == latestValue)
        }

        @Test
        func testWhenNothingStoredForCodableShouldReturnInitialValue() {
            // Arrange
            let initialValue = TestData.createCredentials()
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            let property = TestData.createCredentialsProperty(initial: initialValue, keychain: keychain)

            // Act
            let result = property.wrappedValue

            // Assert
            #expect(result == initialValue)
        }
    }

    @Suite("Default Configuration")
    struct DefaultConfiguration {

        @Test
        func testWhenKeychainNotProvidedShouldUseBundleIdentifierService() {
            // Arrange
            let key = TestData.tokenKey
            let initialValue = TestData.initialToken
            let expectedService = Bundle.main.bundleIdentifier ?? ""

            // Act
            let property = KeychainProperty(key, initial: initialValue)

            // Assert
            #expect(property.key == key)
            #expect(property.initialValue == initialValue)
            #expect(property.keychain.service == expectedService)
        }
    }

    @Suite("Property Wrapper Usage")
    struct PropertyWrapperUsage {

        @Test
        func testWhenUsedAsAttributeWithEmptyKeychainShouldReturnInitialValue() {
            // Arrange
            let initialValue = TestData.initialToken
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }

            // Act
            let storage = TestStorage(initial: initialValue, keychain: keychain)

            // Assert
            #expect(storage.token == initialValue)
        }

        @Test
        func testWhenUsedAsAttributeShouldRoundTripValue() {
            // Arrange
            let storedValue = TestData.storedToken
            let keychain = KeychainTestEnvironment.makeIsolatedKeychain()
            defer { try? keychain.removeAll() }
            var storage = TestStorage(keychain: keychain)

            // Act
            storage.token = storedValue

            // Assert
            #expect(storage.token == storedValue)
        }
    }
}

private struct TestStorage {
    @KeychainProperty<String> var token: String

    init(key: String = TestData.tokenKey, initial: String = TestData.initialToken, keychain: Keychain) {
        _token = KeychainProperty(key, initial: initial, keychain: keychain)
    }
}

private struct TestCredentials: Codable, Equatable {
    struct Scope: Codable, Equatable {
        let name: String
        let isEnabled: Bool
    }

    let identifier: String
    let token: String
    let issuedAt: Date
    let refreshCount: Int
    let scopes: [Scope]
}

private enum TestData {
    static let tokenKey = "access.token"
    static let secondaryKey = "refresh.token"
    static let measurementKey = "session.duration"

    static let initialToken = "initial-token"
    static let storedToken = "stored-token"
    static let updatedToken = "updated-token"
    static let tokenVariants = ["", "token with spaces", "токен-🔐", String(repeating: "x", count: 2048)]

    static let initialMeasurement = 1.5
    static let storedMeasurement = 42.25
    static let nonEncodableMeasurement = Double.infinity

    static let fixedDate = Date(timeIntervalSince1970: 1609459200)
    static let defaultIdentifier = "F9C4B0E2-0000-4000-A000-000000000001"
    static let defaultRefreshCount = 3
    static let updatedRefreshCount = 7
    static let corruptedPayload = Data([0xFF, 0xFE, 0xFD])

    static func createTokenProperty(
        key: String = tokenKey,
        initial: String = initialToken,
        keychain: Keychain
    ) -> KeychainProperty<String> {
        KeychainProperty(key, initial: initial, keychain: keychain)
    }

    static func createOptionalTokenProperty(
        key: String = tokenKey,
        initial: String? = initialToken,
        keychain: Keychain
    ) -> KeychainProperty<String?> {
        KeychainProperty(key, initial: initial, keychain: keychain)
    }

    static func createMeasurementProperty(
        key: String = measurementKey,
        initial: Double = initialMeasurement,
        keychain: Keychain
    ) -> KeychainProperty<Double> {
        KeychainProperty(key, initial: initial, keychain: keychain)
    }

    static func createCredentialsProperty(
        key: String = tokenKey,
        initial: TestCredentials = createCredentials(token: initialToken),
        keychain: Keychain
    ) -> KeychainProperty<TestCredentials> {
        KeychainProperty(key, initial: initial, keychain: keychain)
    }

    static func createCredentialsListProperty(
        key: String = tokenKey,
        initial: [TestCredentials] = [],
        keychain: Keychain
    ) -> KeychainProperty<[TestCredentials]> {
        KeychainProperty(key, initial: initial, keychain: keychain)
    }

    static func createCredentials(
        identifier: String = defaultIdentifier,
        token: String = storedToken,
        issuedAt: Date = fixedDate,
        refreshCount: Int = defaultRefreshCount,
        scopes: [TestCredentials.Scope] = [TestCredentials.Scope(name: "read", isEnabled: true), TestCredentials.Scope(name: "write", isEnabled: false)]
    ) -> TestCredentials {
        TestCredentials(
            identifier: identifier,
            token: token,
            issuedAt: issuedAt,
            refreshCount: refreshCount,
            scopes: scopes
        )
    }
}
