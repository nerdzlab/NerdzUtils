//
//  StringLocalizationTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private enum TestData {

    static let missingKey = "nz.tests.missing.localization.key"
    static let emptyKey = ""
    static let overridenLocaleIdentifier = "uk"
    static let blankLocaleIdentifier = "  "
    static let unknownLocaleIdentifier = "zz-ZZ"

    static func createMissingKeys() -> [String] {
        [missingKey, "\(missingKey).one", "\(missingKey).two"]
    }
}

@Suite("String Localization")
struct StringLocalizationTests {

    @Suite("Localized Value")
    struct LocalizedValue {

        @Test(arguments: TestData.createMissingKeys())
        func testWhenKeyIsMissingShouldReturnKeyItself(key: String) {
            // Arrange
            let localizationKey = key

            // Act
            let localized = localizationKey.nz.localized

            // Assert
            #expect(localized == localizationKey)
        }

        @Test
        func testWhenKeyIsEmptyShouldReturnEmptyString() {
            // Arrange
            let localizationKey = TestData.emptyKey

            // Act
            let localized = localizationKey.nz.localized

            // Assert
            #expect(localized == localizationKey)
        }
    }

    @Suite("Overriden Locale", .serialized)
    struct OverridenLocale {

        @Test
        func testWhenOverridenLocaleIsSetShouldReturnStoredValue() {
            // Arrange
            let previousValue = String.nz.overridenLocale
            let identifier = TestData.overridenLocaleIdentifier

            defer { String.nz.overridenLocale = previousValue }

            // Act
            String.nz.overridenLocale = identifier

            // Assert
            #expect(String.nz.overridenLocale == identifier)
        }

        @Test
        func testWhenOverridenLocaleIsResetShouldReturnNil() {
            // Arrange
            let previousValue = String.nz.overridenLocale

            defer { String.nz.overridenLocale = previousValue }

            String.nz.overridenLocale = TestData.overridenLocaleIdentifier

            // Act
            String.nz.overridenLocale = nil

            // Assert
            #expect(String.nz.overridenLocale == nil)
        }

        @Test(arguments: [TestData.unknownLocaleIdentifier, TestData.blankLocaleIdentifier])
        func testWhenOverridenLocaleHasNoBundleShouldFallBackToMainBundle(identifier: String) {
            // Arrange
            let previousValue = String.nz.overridenLocale
            let localizationKey = TestData.missingKey

            defer { String.nz.overridenLocale = previousValue }

            String.nz.overridenLocale = identifier

            // Act
            let localized = localizationKey.nz.localized

            // Assert
            #expect(localized == localizationKey)
        }
    }
}
