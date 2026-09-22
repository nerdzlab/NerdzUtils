import Testing
import Foundation
@testable import NerdzDate

@Suite("Formatter iso8601")
struct FormatterISO8601Tests {

    @Suite("Plain formatter")
    struct PlainFormatter {

        @Test
        func testWhenDateFormattedShouldProduceInternetDateTimeString() {
            // Arrange
            let date = TestData.referenceDate

            // Act
            let result = Formatter.nz.iso8601.string(from: date)

            // Assert
            #expect(result == TestData.referenceString)
        }

        @Test
        func testWhenStringParsedShouldProduceReferenceDate() {
            // Arrange
            let string = TestData.referenceString

            // Act
            let result = Formatter.nz.iso8601.date(from: string)

            // Assert
            #expect(result == TestData.referenceDate)
        }

        @Test
        func testWhenStringWithFractionalSecondsParsedShouldReturnNil() {
            // Arrange
            let string = TestData.fractionalString

            // Act
            let result = Formatter.nz.iso8601.date(from: string)

            // Assert
            #expect(result == nil)
        }

        @Test(arguments: TestData.invalidStrings)
        func testWhenInvalidStringParsedShouldReturnNil(string: String) {
            // Arrange
            let formatter = Formatter.nz.iso8601

            // Act
            let result = formatter.date(from: string)

            // Assert
            #expect(result == nil)
        }

        @Test
        func testWhenFormatterRequestedShouldUseGmtTimeZone() throws {
            // Arrange
            let expectedIdentifier = TestData.gmtIdentifier

            // Act
            let timeZone = try #require(Formatter.nz.iso8601.timeZone)

            // Assert
            #expect(timeZone.identifier == expectedIdentifier)
        }

        @Test
        func testWhenFormatterRequestedTwiceShouldReturnSameCachedInstance() {
            // Arrange
            let first = Formatter.nz.iso8601

            // Act
            let second = Formatter.nz.iso8601

            // Assert
            #expect(first === second)
        }
    }

    @Suite("Fractional seconds formatter")
    struct FractionalSecondsFormatter {

        @Test
        func testWhenDateFormattedShouldIncludeFractionalSeconds() {
            // Arrange
            let date = TestData.referenceDate

            // Act
            let result = Formatter.nz.iso8601WithFS.string(from: date)

            // Assert
            #expect(result == TestData.referenceStringWithZeroFraction)
        }

        @Test
        func testWhenFractionalStringParsedShouldKeepFractionalPart() throws {
            // Arrange
            let string = TestData.fractionalString

            // Act
            let result = try #require(Formatter.nz.iso8601WithFS.date(from: string))

            // Assert
            #expect(abs(result.timeIntervalSince1970 - TestData.fractionalTimestamp) < TestData.fractionTolerance)
        }

        @Test
        func testWhenStringWithoutFractionalSecondsParsedShouldReturnNil() {
            // Arrange
            let string = TestData.referenceString

            // Act
            let result = Formatter.nz.iso8601WithFS.date(from: string)

            // Assert
            #expect(result == nil)
        }

        @Test
        func testWhenFormatterRequestedShouldEnableInternetDateTimeAndFractionalSeconds() {
            // Arrange
            let expectedOptions = TestData.fractionalFormatOptions

            // Act
            let options = Formatter.nz.iso8601WithFS.formatOptions

            // Assert
            #expect(options == expectedOptions)
        }

        @Test
        func testWhenFormatterRequestedTwiceShouldReturnSameCachedInstance() {
            // Arrange
            let first = Formatter.nz.iso8601WithFS

            // Act
            let second = Formatter.nz.iso8601WithFS

            // Assert
            #expect(first === second)
        }

        @Test
        func testWhenComparedWithPlainFormatterShouldBeDifferentInstance() {
            // Arrange
            let plain = Formatter.nz.iso8601

            // Act
            let fractional = Formatter.nz.iso8601WithFS

            // Assert
            #expect(plain !== fractional)
        }
    }

    @Suite("Round trip")
    struct RoundTrip {

        @Test(arguments: TestData.roundTripDates)
        func testWhenDateFormattedAndParsedBackShouldStayEqual(date: Date) {
            // Arrange
            let formatter = Formatter.nz.iso8601

            // Act
            let result = formatter.date(from: formatter.string(from: date))

            // Assert
            #expect(result == date)
        }

        @Test(arguments: TestData.roundTripDates)
        func testWhenDateFormattedAndParsedBackWithFractionalSecondsShouldStayEqual(date: Date) {
            // Arrange
            let formatter = Formatter.nz.iso8601WithFS

            // Act
            let result = formatter.date(from: formatter.string(from: date))

            // Assert
            #expect(result == date)
        }
    }
}

private enum TestData {
    static let referenceDate = DateFixtures.referenceDate
    static let fractionalTimestamp = DateFixtures.fractionalTimestamp
    static let referenceStringBody = "2020-09-13T12:26:40"
    static let zuluSuffix = "Z"
    static let referenceString = referenceStringBody + zuluSuffix
    static let referenceStringWithZeroFraction = referenceStringBody + ".000" + zuluSuffix
    static let fractionalString = referenceStringBody + ".123" + zuluSuffix
    static let gmtIdentifier = "GMT"
    static let fractionTolerance: TimeInterval = 0.001
    static let fractionalFormatOptions: ISO8601DateFormatter.Options = [.withInternetDateTime, .withFractionalSeconds]
    static let invalidStrings: [String] = ["", "not a date", "2020-13-45T99:99:99Z", "13/09/2020"]
    static let roundTripDates: [Date] = [DateFixtures.referenceDate, DateFixtures.endOfYearDate, DateFixtures.midWeekDate]
}
