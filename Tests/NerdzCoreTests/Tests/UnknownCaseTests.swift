//
//  UnknownCaseTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

enum UnknownCaseStatus: String, UnknownCase, Decodable {
    case active
    case inactive
    case unknown

    static var unknownCase: UnknownCaseStatus { .unknown }
}

enum UnknownCaseLevel: Int, UnknownCase, Decodable {
    case low = 1
    case high = 2
    case unknown = -1

    static var unknownCase: UnknownCaseLevel { .unknown }
}

private enum TestData {

    static let unknownStringRawValue = "deleted"
    static let unknownIntRawValue = 999
    static let knownStatuses = UnknownCaseStatus.allCases.filter { $0 != UnknownCaseStatus.unknownCase }
    static let knownLevels = UnknownCaseLevel.allCases.filter { $0 != UnknownCaseLevel.unknownCase }

    static func createJson(for rawValue: String) -> Data {
        Data(#""\#(rawValue)""#.utf8)
    }

    static func createJson(for rawValue: Int) -> Data {
        Data("\(rawValue)".utf8)
    }

    static func createDecoder() -> JSONDecoder {
        JSONDecoder()
    }
}

@Suite("Unknown Case")
struct UnknownCaseTests {

    @Suite("Raw Value Initialization")
    struct RawValueInitialization {

        @Test(arguments: TestData.knownStatuses)
        func testWhenRawValueIsKnownShouldReturnMatchingCase(status: UnknownCaseStatus) {
            // Arrange
            let rawValue = status.rawValue

            // Act
            let restored: UnknownCaseStatus = UnknownCaseStatus(rawValue: rawValue)

            // Assert
            #expect(restored == status)
        }

        @Test
        func testWhenRawValueIsUnknownShouldReturnUnknownCase() {
            // Arrange
            let rawValue = TestData.unknownStringRawValue

            // Act
            let restored: UnknownCaseStatus = UnknownCaseStatus(rawValue: rawValue)

            // Assert
            #expect(restored == UnknownCaseStatus.unknownCase)
        }

        @Test(arguments: TestData.knownLevels)
        func testWhenIntRawValueIsKnownShouldReturnMatchingCase(level: UnknownCaseLevel) {
            // Arrange
            let rawValue = level.rawValue

            // Act
            let restored: UnknownCaseLevel = UnknownCaseLevel(rawValue: rawValue)

            // Assert
            #expect(restored == level)
        }

        @Test
        func testWhenIntRawValueIsUnknownShouldReturnUnknownCase() {
            // Arrange
            let rawValue = TestData.unknownIntRawValue

            // Act
            let restored: UnknownCaseLevel = UnknownCaseLevel(rawValue: rawValue)

            // Assert
            #expect(restored == UnknownCaseLevel.unknownCase)
        }
    }

    @Suite("Decoding")
    struct Decoding {

        @Test(arguments: TestData.knownStatuses)
        func testWhenDecodedRawValueIsKnownShouldReturnMatchingCase(status: UnknownCaseStatus) throws {
            // Arrange
            let json = TestData.createJson(for: status.rawValue)

            // Act
            let decoded = try TestData.createDecoder().decode(UnknownCaseStatus.self, from: json)

            // Assert
            #expect(decoded == status)
        }

        @Test
        func testWhenDecodedRawValueIsUnknownShouldReturnUnknownCase() throws {
            // Arrange
            let json = TestData.createJson(for: TestData.unknownStringRawValue)

            // Act
            let decoded = try TestData.createDecoder().decode(UnknownCaseStatus.self, from: json)

            // Assert
            #expect(decoded == UnknownCaseStatus.unknownCase)
        }

        @Test(arguments: TestData.knownLevels)
        func testWhenDecodedIntRawValueIsKnownShouldReturnMatchingCase(level: UnknownCaseLevel) throws {
            // Arrange
            let json = TestData.createJson(for: level.rawValue)

            // Act
            let decoded = try TestData.createDecoder().decode(UnknownCaseLevel.self, from: json)

            // Assert
            #expect(decoded == level)
        }

        @Test
        func testWhenDecodedIntRawValueIsUnknownShouldReturnUnknownCase() throws {
            // Arrange
            let json = TestData.createJson(for: TestData.unknownIntRawValue)

            // Act
            let decoded = try TestData.createDecoder().decode(UnknownCaseLevel.self, from: json)

            // Assert
            #expect(decoded == UnknownCaseLevel.unknownCase)
        }

        @Test
        func testWhenDecodedRawValueHasWrongTypeShouldThrow() {
            // Arrange
            let json = TestData.createJson(for: TestData.unknownIntRawValue)

            // Act & Assert
            #expect(throws: DecodingError.self) {
                try TestData.createDecoder().decode(UnknownCaseStatus.self, from: json)
            }
        }
    }
}
