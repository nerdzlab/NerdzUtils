//
//  DefaultsPropertyTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private enum TestData {

    static let key = "nz.tests.defaults.key"
    static let initialNumber = 11
    static let storedNumber = 42
    static let initialText = "initial"
    static let storedText = "stored"
    static let initialDouble: Double = 1.5
    static let corruptedData = Data("not a json".utf8)

    struct Settings: Codable, Equatable {
        let identifier: Int
        let title: String
    }

    static func createSettings(identifier: Int = storedNumber, title: String = storedText) -> Settings {
        Settings(identifier: identifier, title: title)
    }

    static func createNumberProperty(defaults: UserDefaults, initial: Int = initialNumber) -> DefaultsProperty<Int> {
        DefaultsProperty(key, initial: initial, defaults: defaults)
    }

    static func createTextProperty(defaults: UserDefaults, initial: String = initialText) -> DefaultsProperty<String> {
        DefaultsProperty(key, initial: initial, defaults: defaults)
    }

    static func createOptionalTextProperty(defaults: UserDefaults, initial: String? = nil) -> DefaultsProperty<String?> {
        DefaultsProperty(key, initial: initial, defaults: defaults)
    }

    static func createSettingsProperty(defaults: UserDefaults, initial: Settings) -> DefaultsProperty<Settings> {
        DefaultsProperty(key, initial: initial, defaults: defaults)
    }

    static func createDoubleProperty(defaults: UserDefaults, initial: Double = initialDouble) -> DefaultsProperty<Double> {
        DefaultsProperty(key, initial: initial, defaults: defaults)
    }
}

@Suite("Defaults Property")
struct DefaultsPropertyTests {

    @Suite("Reading")
    struct Reading {

        @Test
        func testWhenNoValueIsStoredShouldReturnInitialValue() throws {
            // Arrange
            let storage = try TemporaryDefaults()
            let initialValue = TestData.initialNumber

            defer { storage.remove() }

            // Act
            let property = TestData.createNumberProperty(defaults: storage.defaults, initial: initialValue)

            // Assert
            #expect(property.wrappedValue == initialValue)
        }

        @Test
        func testWhenStoredDataIsCorruptedShouldReturnInitialValue() throws {
            // Arrange
            let storage = try TemporaryDefaults()
            let initialValue = TestData.initialText

            defer { storage.remove() }

            storage.defaults.setValue(TestData.corruptedData, forKey: TestData.key)

            // Act
            let property = TestData.createTextProperty(defaults: storage.defaults, initial: initialValue)

            // Assert
            #expect(property.wrappedValue == initialValue)
        }

        @Test
        func testWhenStoredValueHasDifferentTypeShouldReturnInitialValue() throws {
            // Arrange
            let storage = try TemporaryDefaults()
            let initialValue = TestData.initialNumber

            defer { storage.remove() }

            var textProperty = TestData.createTextProperty(defaults: storage.defaults)
            textProperty.wrappedValue = TestData.storedText

            // Act
            let property = TestData.createNumberProperty(defaults: storage.defaults, initial: initialValue)

            // Assert
            #expect(property.wrappedValue == initialValue)
        }
    }

    @Suite("Writing")
    struct Writing {

        @Test
        func testWhenValueIsSetShouldReturnStoredValue() throws {
            // Arrange
            let storage = try TemporaryDefaults()
            let newValue = TestData.storedNumber

            defer { storage.remove() }

            var property = TestData.createNumberProperty(defaults: storage.defaults)

            // Act
            property.wrappedValue = newValue

            // Assert
            #expect(property.wrappedValue == newValue)
        }

        @Test
        func testWhenValueIsSetShouldPersistItIntoDefaults() throws {
            // Arrange
            let storage = try TemporaryDefaults()
            let newValue = TestData.storedNumber

            defer { storage.remove() }

            var property = TestData.createNumberProperty(defaults: storage.defaults)

            // Act
            property.wrappedValue = newValue

            // Assert
            let storedData = try #require(storage.defaults.data(forKey: TestData.key))
            #expect(try JSONDecoder().decode(Int.self, from: storedData) == newValue)
        }

        @Test
        func testWhenValueIsCodableStructShouldRoundTripIt() throws {
            // Arrange
            let storage = try TemporaryDefaults()
            let newValue = TestData.createSettings()

            defer { storage.remove() }

            var property = TestData.createSettingsProperty(
                defaults: storage.defaults,
                initial: TestData.createSettings(identifier: TestData.initialNumber, title: TestData.initialText)
            )

            // Act
            property.wrappedValue = newValue

            // Assert
            #expect(property.wrappedValue == newValue)
        }

        @Test
        func testWhenValueIsOptionalAndSetToNilShouldReturnNil() throws {
            // Arrange
            let storage = try TemporaryDefaults()

            defer { storage.remove() }

            var property = TestData.createOptionalTextProperty(defaults: storage.defaults, initial: TestData.initialText)
            property.wrappedValue = TestData.storedText

            // Act
            property.wrappedValue = nil

            // Assert
            #expect(property.wrappedValue == nil)
        }

        @Test
        func testWhenTwoPropertiesShareKeyShouldSeeSameValue() throws {
            // Arrange
            let storage = try TemporaryDefaults()
            let newValue = TestData.storedNumber

            defer { storage.remove() }

            var writer = TestData.createNumberProperty(defaults: storage.defaults)
            let reader = TestData.createNumberProperty(defaults: storage.defaults)

            // Act
            writer.wrappedValue = newValue

            // Assert
            #expect(reader.wrappedValue == newValue)
        }
    }

    @Suite("Non Encodable Values")
    struct NonEncodableValues {

        @Test
        func testWhenNewValueIsNotEncodableShouldReturnInitialValue() throws {
            // Arrange
            let storage = try TemporaryDefaults()
            let initialValue = TestData.initialDouble

            defer { storage.remove() }

            var property = TestData.createDoubleProperty(defaults: storage.defaults, initial: initialValue)

            // Act
            property.wrappedValue = .infinity

            // Assert
            #expect(property.wrappedValue == initialValue)
        }

        @Test
        func testWhenNewValueIsNotEncodableShouldRemoveStoredValue() throws {
            // Arrange
            let storage = try TemporaryDefaults()

            defer { storage.remove() }

            var property = TestData.createDoubleProperty(defaults: storage.defaults)
            property.wrappedValue = TestData.initialDouble

            // Act
            property.wrappedValue = .nan

            // Assert
            #expect(storage.defaults.data(forKey: TestData.key) == nil)
        }
    }
}
