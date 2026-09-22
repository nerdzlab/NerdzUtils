import Testing
import Foundation
import NerdzCore
@testable import NerdzDate

private typealias Weekday = NZExtensionData<Date>.Weekday

@Suite("Date weekday")
struct DateWeekDayTests {

    @Suite("Weekday raw values")
    struct WeekdayRawValues {

        @Test(arguments: TestData.weekdayCases)
        func testWhenWeekdayCreatedFromRawValueShouldMatchGregorianNumbering(rawValue: Int) throws {
            // Arrange
            let expected = rawValue

            // Act
            let weekday = try #require(Weekday(rawValue: expected))

            // Assert
            #expect(weekday.rawValue == expected)
        }

        @Test
        func testWhenFirstAndLastWeekdaysUsedShouldCoverWholeWeek() {
            // Arrange
            let expectedRange = TestData.weekdayRange

            // Act
            let first = Weekday.sunday.rawValue
            let last = Weekday.saturday.rawValue

            // Assert
            #expect(first == expectedRange.lowerBound)
            #expect(last == expectedRange.upperBound)
        }
    }

    @Suite("Next weekday")
    struct NextWeekday {

        @Test(arguments: TestData.weekdayCases)
        func testWhenNextRequestedShouldReturnDateWithRequestedWeekday(rawValue: Int) throws {
            // Arrange
            let base = DateFixtures.referenceDate
            let weekday = try #require(Weekday(rawValue: rawValue))
            let calendar = DateFixtures.gregorianCalendar

            // Act
            let result = try #require(base.nz.next(weekday))

            // Assert
            #expect(calendar.component(.weekday, from: result) == rawValue)
        }

        @Test(arguments: TestData.weekdayCases)
        func testWhenNextRequestedShouldReturnDateWithinFollowingWeek(rawValue: Int) throws {
            // Arrange
            let base = DateFixtures.referenceDate
            let weekday = try #require(Weekday(rawValue: rawValue))

            // Act
            let result = try #require(base.nz.next(weekday))

            // Assert
            #expect(result > base)
            #expect(result.timeIntervalSince(base) <= TestData.weekInterval)
        }

        @Test
        func testWhenNextRequestedForTodayWithoutConsiderTodayShouldSkipToFollowingWeek() throws {
            // Arrange
            let base = DateFixtures.referenceDate
            let calendar = DateFixtures.gregorianCalendar
            let todayWeekday = try #require(Weekday(rawValue: calendar.component(.weekday, from: base)))

            // Act
            let result = try #require(base.nz.next(todayWeekday))

            // Assert
            #expect(result != base)
            #expect(result > base)
        }

        @Test
        func testWhenNextRequestedForTodayWithConsiderTodayShouldReturnBaseDate() throws {
            // Arrange
            let base = DateFixtures.referenceDate
            let calendar = DateFixtures.gregorianCalendar
            let todayWeekday = try #require(Weekday(rawValue: calendar.component(.weekday, from: base)))

            // Act
            let result = try #require(base.nz.next(todayWeekday, considerToday: true))

            // Assert
            #expect(result == base)
        }

        @Test
        func testWhenNextRequestedForAnotherWeekdayWithConsiderTodayShouldReturnFutureDate() throws {
            // Arrange
            let base = DateFixtures.referenceDate
            let calendar = DateFixtures.gregorianCalendar
            let todayNumber = calendar.component(.weekday, from: base)
            let otherWeekday = try #require(Weekday(rawValue: TestData.nextWeekdayNumber(after: todayNumber)))

            // Act
            let result = try #require(base.nz.next(otherWeekday, considerToday: true))

            // Assert
            #expect(result > base)
            #expect(calendar.component(.weekday, from: result) == otherWeekday.rawValue)
        }
    }

    @Suite("Previous weekday")
    struct PreviousWeekday {

        @Test(arguments: TestData.weekdayCases)
        func testWhenPreviousRequestedShouldReturnDateWithRequestedWeekday(rawValue: Int) throws {
            // Arrange
            let base = DateFixtures.midWeekDate
            let weekday = try #require(Weekday(rawValue: rawValue))
            let calendar = DateFixtures.gregorianCalendar

            // Act
            let result = try #require(base.nz.previous(weekday))

            // Assert
            #expect(calendar.component(.weekday, from: result) == rawValue)
        }

        @Test(arguments: TestData.weekdayCases)
        func testWhenPreviousRequestedShouldReturnDateWithinPrecedingWeek(rawValue: Int) throws {
            // Arrange
            let base = DateFixtures.midWeekDate
            let weekday = try #require(Weekday(rawValue: rawValue))

            // Act
            let result = try #require(base.nz.previous(weekday))

            // Assert
            #expect(result < base)
            #expect(base.timeIntervalSince(result) <= TestData.backwardSearchWindow)
        }

        @Test
        func testWhenPreviousRequestedForTodayWithConsiderTodayShouldReturnBaseDate() throws {
            // Arrange
            let base = DateFixtures.midWeekDate
            let calendar = DateFixtures.gregorianCalendar
            let todayWeekday = try #require(Weekday(rawValue: calendar.component(.weekday, from: base)))

            // Act
            let result = try #require(base.nz.previous(todayWeekday, considerToday: true))

            // Assert
            #expect(result == base)
        }

        @Test
        func testWhenPreviousRequestedForTodayWithoutConsiderTodayShouldReturnEarlierDate() throws {
            // Arrange
            let base = DateFixtures.midWeekDate
            let calendar = DateFixtures.gregorianCalendar
            let todayWeekday = try #require(Weekday(rawValue: calendar.component(.weekday, from: base)))

            // Act
            let result = try #require(base.nz.previous(todayWeekday))

            // Assert
            #expect(result < base)
        }
    }

    @Suite("Search result time")
    struct SearchResultTime {

        @Test(arguments: TestData.weekdayCases)
        func testWhenWeekdayFoundShouldStartAtMidnight(rawValue: Int) throws {
            // Arrange
            let base = DateFixtures.referenceDate
            let weekday = try #require(Weekday(rawValue: rawValue))
            let calendar = DateFixtures.gregorianCalendar

            // Act
            let result = try #require(base.nz.next(weekday))

            // Assert
            #expect(calendar.component(.hour, from: result) == TestData.midnightUnitValue)
            #expect(calendar.component(.minute, from: result) == TestData.midnightUnitValue)
            #expect(calendar.component(.second, from: result) == TestData.midnightUnitValue)
        }
    }
}

private enum TestData {
    static let weekdayRange = 1...7
    static let weekdayCases: [Int] = Array(weekdayRange)
    static let weekInterval: TimeInterval = 7 * 86_400
    static let backwardSearchWindow: TimeInterval = 8 * 86_400
    static let midnightUnitValue = 0

    static func nextWeekdayNumber(after number: Int) -> Int {
        number == weekdayRange.upperBound ? weekdayRange.lowerBound : number + 1
    }
}
