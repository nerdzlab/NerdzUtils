//
//  DataObjectTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private enum TestData {

    static let userId = 42
    static let userName = "Nerdz"
    static let isoDateString = "2021-01-01T00:00:00Z"
    static let fixedDate = Date(timeIntervalSince1970: 1_609_459_200)
    static let malformedJson = Data("{".utf8)
    static let emptyData = Data()

    struct User: Codable, Equatable {
        let id: Int
        let name: String
        let createdAt: Date
    }

    static func createUserJson(id: Int = userId, name: String = userName, date: String = isoDateString) -> Data {
        Data(#"{"id":\#(id),"name":"\#(name)","createdAt":"\#(date)"}"#.utf8)
    }

    static func createUser(id: Int = userId, name: String = userName, date: Date = fixedDate) -> User {
        User(id: id, name: name, createdAt: date)
    }

    static func createTypeMismatchedJson() -> Data {
        Data(#"{"id":"not-a-number","name":"\#(userName)","createdAt":"\#(isoDateString)"}"#.utf8)
    }

    static func createIncompleteJson() -> Data {
        Data(#"{"id":\#(userId)}"#.utf8)
    }
}

@Suite("Data Object Decoding")
struct DataObjectTests {

    @Suite("Valid Json")
    struct ValidJson {

        @Test
        func testWhenDataContainsValidJsonShouldReturnDecodedObject() throws {
            // Arrange
            let data = TestData.createUserJson()

            // Act
            let decoded = try #require(try data.nz.object(of: TestData.User.self))

            // Assert
            #expect(decoded == TestData.createUser())
        }

        @Test
        func testWhenTargetTypeIsInferredShouldReturnDecodedObject() throws {
            // Arrange
            let data = TestData.createUserJson()

            // Act
            let decoded: TestData.User = try #require(try data.nz.object())

            // Assert
            #expect(decoded == TestData.createUser())
        }

        @Test
        func testWhenJsonContainsIso8601DateShouldDecodeItUsingIso8601Strategy() throws {
            // Arrange
            let data = TestData.createUserJson()

            // Act
            let decoded = try #require(try data.nz.object(of: TestData.User.self))

            // Assert
            #expect(decoded.createdAt == TestData.fixedDate)
        }

        @Test
        func testWhenJsonContainsPrimitiveShouldDecodeIt() throws {
            // Arrange
            let expectedValue = TestData.userId
            let data = Data("\(expectedValue)".utf8)

            // Act
            let decoded = try #require(try data.nz.object(of: Int.self))

            // Assert
            #expect(decoded == expectedValue)
        }
    }

    @Suite("Invalid Json")
    struct InvalidJson {

        @Test
        func testWhenDataIsMalformedShouldThrow() {
            // Arrange
            let data = TestData.malformedJson

            // Act & Assert
            #expect(throws: DecodingError.self) {
                try data.nz.object(of: TestData.User.self)
            }
        }

        @Test
        func testWhenDataIsEmptyShouldThrow() {
            // Arrange
            let data = TestData.emptyData

            // Act & Assert
            #expect(throws: DecodingError.self) {
                try data.nz.object(of: TestData.User.self)
            }
        }

        @Test
        func testWhenJsonHasMismatchedTypeShouldThrow() {
            // Arrange
            let data = TestData.createTypeMismatchedJson()

            // Act & Assert
            #expect(throws: DecodingError.self) {
                try data.nz.object(of: TestData.User.self)
            }
        }

        @Test
        func testWhenJsonMissesRequiredKeysShouldThrow() {
            // Arrange
            let data = TestData.createIncompleteJson()

            // Act & Assert
            #expect(throws: DecodingError.self) {
                try data.nz.object(of: TestData.User.self)
            }
        }
    }
}
