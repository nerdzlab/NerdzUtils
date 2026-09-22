import Testing
import Foundation
import NerdzCore
@testable import NerdzDate

@Suite("DateDecodingStrategy custom iso8601")
struct DateDecodingStrategyCustomISO8601Tests {

    @Suite("Namespace conformance")
    struct NamespaceConformance {

        @Test
        func testWhenDataDecodingStrategyCheckedShouldConformToNamespaceProtocol() {
            // Arrange
            let type = JSONDecoder.DataDecodingStrategy.self

            // Act
            let conforms = ConformanceProbe.isNZExtensionCompatible(type)

            // Assert
            #expect(conforms)
        }

        @Test
        func testWhenDateDecodingStrategyCheckedShouldNotConformToNamespaceProtocol() {
            // Arrange
            let type = JSONDecoder.DateDecodingStrategy.self

            // Act
            let conforms = ConformanceProbe.isNZExtensionCompatible(type)

            // Assert
            #expect(conforms == false)
        }
    }

    @Suite("Decoding behaviour of the declared strategy")
    struct DecodingBehaviour {

        @Test(arguments: TestData.validPayloads)
        fileprivate func testWhenSupportedFormatDecodedShouldProduceExpectedDate(payload: TestData.Payload) throws {
            // Arrange
            let decoder = TestData.makeDecoder()
            let json = TestData.makeJSON(dateString: payload.string)

            // Act
            let result = try decoder.decode(TestData.Box.self, from: json)

            // Assert
            #expect(abs(result.date.timeIntervalSince1970 - payload.timestamp) < TestData.tolerance)
        }

        @Test(arguments: TestData.invalidStrings)
        func testWhenUnsupportedFormatDecodedShouldThrowDecodingError(string: String) {
            // Arrange
            let decoder = TestData.makeDecoder()
            let json = TestData.makeJSON(dateString: string)

            // Act & Assert
            #expect(throws: DecodingError.self) {
                try decoder.decode(TestData.Box.self, from: json)
            }
        }

        @Test
        func testWhenNonStringValueDecodedShouldThrowDecodingError() {
            // Arrange
            let decoder = TestData.makeDecoder()
            let json = TestData.numericPayloadJSON

            // Act & Assert
            #expect(throws: DecodingError.self) {
                try decoder.decode(TestData.Box.self, from: json)
            }
        }
    }
}

private enum TestData {
    static let tolerance: TimeInterval = 0.001
    static let invalidStrings: [String] = ["", "2020-09-13", "yesterday"]

    struct Payload: Sendable {
        let string: String
        let timestamp: TimeInterval
    }

    struct Box: Decodable {
        let date: Date
    }

    static let validPayloads: [Payload] = [
        Payload(
            string: Formatter.nz.iso8601.string(from: DateFixtures.referenceDate),
            timestamp: DateFixtures.referenceTimestamp
        ),
        Payload(
            string: Formatter.nz.iso8601WithFS.string(from: Date(timeIntervalSince1970: DateFixtures.fractionalTimestamp)),
            timestamp: DateFixtures.fractionalTimestamp
        )
    ]

    static let numericPayloadJSON = Data(#"{"date": 12}"#.utf8)

    static func makeJSON(dateString: String) -> Data {
        Data(#"{"date": "\#(dateString)"}"#.utf8)
    }

    static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder throws -> Date in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            if let date = Formatter.nz.iso8601WithFS.date(from: string) ?? Formatter.nz.iso8601.date(from: string) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
        }
        return decoder
    }
}
