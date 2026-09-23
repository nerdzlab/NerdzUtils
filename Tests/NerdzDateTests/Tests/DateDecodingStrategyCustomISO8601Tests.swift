import Testing
import Foundation
import NerdzCore
@testable import NerdzDate

@Suite("DateDecodingStrategy custom iso8601")
struct DateDecodingStrategyCustomISO8601Tests {

    @Suite("Namespace reachability")
    struct NamespaceReachability {

        @Test
        func testWhenDateDecodingStrategyCheckedShouldConformToNamespaceProtocol() {
            // Arrange
            let type = JSONDecoder.DateDecodingStrategy.self

            // Act
            let conforms = ConformanceProbe.isNZExtensionCompatible(type)

            // Assert
            #expect(conforms)
        }

        @Test
        func testWhenDataDecodingStrategyCheckedShouldNotConformToNamespaceProtocol() {
            // Arrange
            let type = JSONDecoder.DataDecodingStrategy.self

            // Act
            let conforms = ConformanceProbe.isNZExtensionCompatible(type)

            // Assert
            #expect(conforms == false)
        }

        @Test
        func testWhenStrategyRequestedThroughNamespaceShouldBeCustomCase() {
            // Arrange
            let strategy = JSONDecoder.DateDecodingStrategy.nz.customISO8601

            // Act
            var isCustom = false
            if case .custom = strategy {
                isCustom = true
            }

            // Assert
            #expect(isCustom)
        }
    }

    @Suite("Decoding through the namespace strategy")
    struct Decoding {

        @Test
        func testWhenFractionalSecondsStringDecodedShouldProduceMatchingDate() throws {
            // Arrange
            let decoder = TestData.makeDecoder()
            let expected = TestData.fractionalDate
            let json = TestData.makeJSON(dateString: Formatter.nz.iso8601WithFS.string(from: expected))

            // Act
            let result = try decoder.decode(TestData.Box.self, from: json)

            // Assert
            #expect(abs(result.date.timeIntervalSince(expected)) < TestData.tolerance)
        }

        @Test
        func testWhenPlainStringDecodedShouldProduceMatchingDateThroughFallback() throws {
            // Arrange
            let decoder = TestData.makeDecoder()
            let expected = DateFixtures.referenceDate
            let dateString = Formatter.nz.iso8601.string(from: expected)
            let json = TestData.makeJSON(dateString: dateString)

            // Act
            let result = try decoder.decode(TestData.Box.self, from: json)

            // Assert
            #expect(Formatter.nz.iso8601WithFS.date(from: dateString) == nil)
            #expect(result.date == expected)
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
    static let fractionalDate = Date(timeIntervalSince1970: DateFixtures.fractionalTimestamp)
    static let numericPayloadJSON = Data(#"{"date": 12}"#.utf8)

    struct Box: Decodable {
        let date: Date
    }

    static func makeJSON(dateString: String) -> Data {
        Data(#"{"date": "\#(dateString)"}"#.utf8)
    }

    static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.nz.customISO8601
        return decoder
    }
}
