//
//  EncodableJsonDataTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private enum TestData {

    static let userId = 7
    static let userName = "Encodable"
    static let fixedDate = Date(timeIntervalSince1970: 1_609_459_200)

    struct User: Codable, Equatable {
        let id: Int
        let name: String
        let createdAt: Date
    }

    struct DatedPayload: Encodable {
        let createdAt: Date
    }

    static func createUser(id: Int = userId, name: String = userName, date: Date = fixedDate) -> User {
        User(id: id, name: name, createdAt: date)
    }

    static func createDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return decoder
    }

    static func createIso8601String(from date: Date = fixedDate) -> String {
        ISO8601DateFormatter().string(from: date)
    }
}

@Suite("Encodable Json Data")
struct EncodableJsonDataTests {

    @Suite("Successful Encoding")
    struct SuccessfulEncoding {

        @Test
        func testWhenObjectIsEncodableShouldReturnJsonData() throws {
            // Arrange
            let user = TestData.createUser()

            // Act
            let data = try #require(user.nz_jsonData)

            // Assert
            #expect(try TestData.createDecoder().decode(TestData.User.self, from: data) == user)
        }

        @Test
        func testWhenObjectContainsDateShouldEncodeItUsingIso8601Strategy() throws {
            // Arrange
            let date = TestData.fixedDate
            let payload = TestData.DatedPayload(createdAt: date)

            // Act
            let data = try #require(payload.nz_jsonData)

            // Assert
            let decoded = try JSONDecoder().decode([String: String].self, from: data)
            #expect(decoded.values.first == TestData.createIso8601String(from: date))
        }

        @Test
        func testWhenValueIsPrimitiveShouldReturnJsonData() throws {
            // Arrange
            let value = TestData.userId

            // Act
            let data = try #require(value.nz_jsonData)

            // Assert
            #expect(try JSONDecoder().decode(Int.self, from: data) == value)
        }

        @Test
        func testWhenValueIsCollectionShouldReturnJsonData() throws {
            // Arrange
            let values = [TestData.userName]

            // Act
            let data = try #require(values.nz_jsonData)

            // Assert
            #expect(try JSONDecoder().decode([String].self, from: data) == values)
        }
    }

    @Suite("Failed Encoding")
    struct FailedEncoding {

        @Test(arguments: [Double.infinity, -Double.infinity, Double.nan])
        func testWhenValueIsNonConformingFloatShouldReturnNil(value: Double) {
            // Arrange
            let payload = value

            // Act
            let data = payload.nz_jsonData

            // Assert
            #expect(data == nil)
        }
    }
}
