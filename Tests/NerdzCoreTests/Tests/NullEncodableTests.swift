//
//  NullEncodableTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private struct Payload: Encodable {
    @NullEncodable var name: String?
}

private struct NestedPayload: Encodable {
    @NullEncodable var settings: Settings?

    struct Settings: Encodable, Equatable {
        let identifier: Int
    }
}

private enum TestData {

    static let key = "name"
    static let nestedKey = "settings"
    static let value = "nerdz"
    static let identifier = 5
    static let nullLiteral = "null"

    static func createPayload(name: String? = value) -> Payload {
        Payload(name: name)
    }

    static func createNestedPayload(identifier: Int? = identifier) -> NestedPayload {
        NestedPayload(settings: identifier.map { NestedPayload.Settings(identifier: $0) })
    }

    static func createEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        return encoder
    }

    static func encodeToString(_ value: some Encodable) throws -> String {
        let data = try createEncoder().encode(value)

        return try #require(String(data: data, encoding: .utf8))
    }
}

@Suite("Null Encodable")
struct NullEncodableTests {

    @Suite("Wrapped Value")
    struct WrappedValue {

        @Test
        func testWhenInitializedWithValueShouldStoreIt() {
            // Arrange
            let expectedValue = TestData.value

            // Act
            let wrapper = NullEncodable(wrappedValue: expectedValue)

            // Assert
            #expect(wrapper.wrappedValue == expectedValue)
        }

        @Test
        func testWhenInitializedWithNilShouldStoreNil() {
            // Arrange
            let wrappedValue: String? = nil

            // Act
            let wrapper = NullEncodable(wrappedValue: wrappedValue)

            // Assert
            #expect(wrapper.wrappedValue == nil)
        }
    }

    @Suite("Encoding")
    struct Encoding {

        @Test
        func testWhenValueIsPresentShouldEncodeValue() throws {
            // Arrange
            let expectedValue = TestData.value
            let payload = TestData.createPayload(name: expectedValue)

            // Act
            let json = try TestData.encodeToString(payload)

            // Assert
            #expect(json == #"{"\#(TestData.key)":"\#(expectedValue)"}"#)
        }

        @Test
        func testWhenValueIsNilShouldEncodeNull() throws {
            // Arrange
            let payload = TestData.createPayload(name: nil)

            // Act
            let json = try TestData.encodeToString(payload)

            // Assert
            #expect(json == #"{"\#(TestData.key)":\#(TestData.nullLiteral)}"#)
        }

        @Test
        func testWhenNestedValueIsPresentShouldEncodeNestedObject() throws {
            // Arrange
            let expectedIdentifier = TestData.identifier
            let payload = TestData.createNestedPayload(identifier: expectedIdentifier)

            // Act
            let json = try TestData.encodeToString(payload)

            // Assert
            #expect(json.contains("\(expectedIdentifier)"))
            #expect(json.contains(TestData.nestedKey))
        }

        @Test
        func testWhenNestedValueIsNilShouldEncodeNull() throws {
            // Arrange
            let payload = TestData.createNestedPayload(identifier: nil)

            // Act
            let json = try TestData.encodeToString(payload)

            // Assert
            #expect(json == #"{"\#(TestData.nestedKey)":\#(TestData.nullLiteral)}"#)
        }

        @Test
        func testWhenEncodedDirectlyShouldEncodeNullLiteral() throws {
            // Arrange
            let wrapper = NullEncodable<String>(wrappedValue: nil)

            // Act
            let json = try TestData.encodeToString(wrapper)

            // Assert
            #expect(json == TestData.nullLiteral)
        }
    }
}
