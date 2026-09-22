import Testing
import Foundation
@testable import NerdzDate

@Suite("Date easy use")
struct DateEasyUseTests {

    @Suite("Now")
    struct Now {

        @Test
        func testWhenNowRequestedShouldReturnCurrentMoment() {
            // Arrange
            let tolerance = TestData.nowTolerance

            // Act
            let result = Date.nz.now

            // Assert
            #expect(abs(result.timeIntervalSince(Date())) < tolerance)
        }
    }

    @Suite("All components")
    struct AllComponents {

        @Test(arguments: TestData.numericComponents)
        func testWhenAllComponentsRequestedShouldMatchSystemCalendarValues(component: Calendar.Component) {
            // Arrange
            let base = DateFixtures.referenceDate
            let calendar = DateFixtures.systemCalendar

            // Act
            let result = base.nz.allComponents

            // Assert
            #expect(result[component] == calendar.component(component, from: base))
        }

        @Test
        func testWhenAllComponentsRequestedShouldCarryCalendarAndTimeZone() {
            // Arrange
            let base = DateFixtures.referenceDate
            let calendar = DateFixtures.systemCalendar

            // Act
            let result = base.nz.allComponents

            // Assert
            #expect(result.calendar == calendar)
            #expect(result.timeZone == calendar.timeZone)
        }

        @Test
        func testWhenAllComponentsConvertedBackShouldRestoreOriginalDate() throws {
            // Arrange
            let base = DateFixtures.referenceDate
            let calendar = DateFixtures.systemCalendar

            // Act
            let restored = try #require(calendar.date(from: base.nz.allComponents))

            // Assert
            #expect(restored == base)
        }
    }

    @Suite("Same day check")
    struct SameDayCheck {

        @Test
        func testWhenComparedWithItselfShouldBeInSameDay() {
            // Arrange
            let base = DateFixtures.referenceDate

            // Act
            let result = base.nz.isInSameDay(as: base)

            // Assert
            #expect(result)
        }

        @Test
        func testWhenComparedWithStartOfItsDayShouldBeInSameDay() {
            // Arrange
            let base = DateFixtures.referenceDate

            // Act
            let result = base.nz.isInSameDay(as: base.nz.start(of: .day))

            // Assert
            #expect(result)
        }

        @Test(arguments: TestData.otherDayOffsets)
        func testWhenComparedWithAnotherDayShouldNotBeInSameDay(offset: Int) {
            // Arrange
            let base = DateFixtures.referenceDate

            // Act
            let result = base.nz.isInSameDay(as: base.nz.adding(.day(offset)))

            // Assert
            #expect(result == false)
        }
    }

    @Suite("Adding range")
    struct AddingRange {

        @Test(arguments: TestData.additionComponents)
        func testWhenRangeAddedShouldShiftDateByRequestedAmount(component: Calendar.Component) throws {
            // Arrange
            let base = DateFixtures.referenceDate
            let value = TestData.additionValue
            let calendar = DateFixtures.systemCalendar

            // Act
            let result = base.nz.adding(DateRange(component: component, value: value))

            // Assert
            #expect(try #require(calendar.dateComponents([component], from: base, to: result).value(for: component)) == value)
        }

        @Test
        func testWhenNegativeRangeAddedShouldReturnEarlierDate() {
            // Arrange
            let base = DateFixtures.referenceDate

            // Act
            let result = base.nz.adding(.day(TestData.negativeAdditionValue))

            // Assert
            #expect(result < base)
        }

        @Test
        func testWhenZeroRangeAddedShouldReturnSameDate() {
            // Arrange
            let base = DateFixtures.referenceDate

            // Act
            let result = base.nz.adding(.minute(TestData.zeroValue))

            // Assert
            #expect(result == base)
        }
    }

    @Suite("Plus operator")
    struct PlusOperator {

        @Test
        func testWhenOperatorUsedShouldMatchAddingCall() {
            // Arrange
            let base = DateFixtures.referenceDate
            let range = DateRange.hour(TestData.additionValue)

            // Act
            let result = base + range

            // Assert
            #expect(result == base.nz.adding(range))
        }
    }

    @Suite("Start of component")
    struct StartOfComponent {

        @Test(arguments: TestData.truncatingStartCases)
        fileprivate func testWhenStartRequestedShouldZeroOutSmallerComponents(startCase: TestData.TruncatingStartCase) {
            // Arrange
            let base = startCase.base
            let calendar = DateFixtures.systemCalendar

            // Act
            let result = base.nz.start(of: startCase.component)

            // Assert
            for zeroed in startCase.component.nz.includedComponents where zeroed != .weekday {
                #expect(calendar.component(zeroed, from: result) == TestData.zeroValue)
            }
        }

        @Test(arguments: TestData.truncatingStartCases)
        fileprivate func testWhenStartRequestedShouldNotBeLaterThanBase(startCase: TestData.TruncatingStartCase) {
            // Arrange
            let base = startCase.base

            // Act
            let result = base.nz.start(of: startCase.component)

            // Assert
            #expect(result <= base)
        }

        @Test
        func testWhenStartOfDayRequestedShouldKeepSameDay() {
            // Arrange
            let base = DateFixtures.referenceDate
            let calendar = DateFixtures.systemCalendar

            // Act
            let result = base.nz.start(of: .day)

            // Assert
            #expect(calendar.isDate(result, inSameDayAs: base))
        }

        @Test
        func testWhenStartOfHourRequestedShouldKeepSameHour() {
            // Arrange
            let base = DateFixtures.referenceDate
            let calendar = DateFixtures.systemCalendar

            // Act
            let result = base.nz.start(of: .hour)

            // Assert
            #expect(calendar.component(.hour, from: result) == calendar.component(.hour, from: base))
        }

        @Test(arguments: TestData.weekComponents)
        func testWhenStartOfWeekRequestedShouldLandOnSunday(component: Calendar.Component) {
            // Arrange
            let base = DateFixtures.midWeekDate
            let calendar = DateFixtures.systemCalendar

            // Act
            let result = base.nz.start(of: component)

            // Assert
            #expect(calendar.component(.weekday, from: result) == TestData.sundayWeekdayNumber)
        }

        @Test(arguments: TestData.weekComponents)
        func testWhenStartOfWeekRequestedShouldStayWithinPrecedingWeek(component: Calendar.Component) {
            // Arrange
            let base = DateFixtures.midWeekDate
            let daysInWeek = TestData.daysInWeek

            // Act
            let result = base.nz.start(of: component)

            // Assert
            #expect(base.timeIntervalSince(result) < TimeInterval(daysInWeek) * TestData.secondsInDay)
        }

        @Test
        func testWhenStartOfMonthRequestedShouldLandOnLastDayOfPreviousMonth() throws {
            // Arrange
            let base = DateFixtures.referenceDate
            let calendar = DateFixtures.systemCalendar
            let previousMonth = try #require(calendar.date(byAdding: .month, value: TestData.negativeStepValue, to: base))

            // Act
            let result = base.nz.start(of: .month)

            // Assert
            #expect(calendar.component(.month, from: result) == calendar.component(.month, from: previousMonth))
            #expect(calendar.component(.day, from: result) == calendar.range(of: .day, in: .month, for: previousMonth)?.count)
        }

        @Test
        func testWhenStartOfYearRequestedShouldLandInPreviousYear() {
            // Arrange
            let base = DateFixtures.referenceDate
            let calendar = DateFixtures.systemCalendar

            // Act
            let result = base.nz.start(of: .year)

            // Assert
            #expect(calendar.component(.year, from: result) == calendar.component(.year, from: base) + TestData.negativeStepValue)
        }
    }

    @Suite("End of component")
    struct EndOfComponent {

        @Test
        func testWhenEndOfDayRequestedShouldBeOneSecondBeforeNextDayStart() {
            // Arrange
            let base = DateFixtures.referenceDate
            let oneSecond = TestData.oneSecondInterval

            // Act
            let result = base.nz.end(of: .day)

            // Assert
            #expect(base.nz.adding(.day(TestData.positiveStepValue)).nz.start(of: .day).timeIntervalSince(result) == oneSecond)
        }

        @Test(arguments: TestData.truncatingStartCases)
        fileprivate func testWhenEndRequestedShouldBeLaterThanStart(startCase: TestData.TruncatingStartCase) {
            // Arrange
            let base = startCase.base

            // Act
            let result = base.nz.end(of: startCase.component)

            // Assert
            #expect(result >= base.nz.start(of: startCase.component))
        }

        @Test
        func testWhenEndOfHourRequestedShouldKeepLastMinuteAndSecond() {
            // Arrange
            let base = DateFixtures.referenceDate
            let calendar = DateFixtures.systemCalendar
            let lastUnitValue = TestData.lastUnitInMinute

            // Act
            let result = base.nz.end(of: .hour)

            // Assert
            #expect(calendar.component(.minute, from: result) == lastUnitValue)
            #expect(calendar.component(.second, from: result) == lastUnitValue)
        }

        @Test
        func testWhenEndOfSecondRequestedShouldEqualStartOfSecond() {
            // Arrange
            let base = DateFixtures.referenceDate

            // Act
            let result = base.nz.end(of: .second)

            // Assert
            #expect(result == base.nz.start(of: .second))
        }
    }

    @Suite("Component subscript")
    struct ComponentSubscript {

        @Test(arguments: TestData.numericComponents)
        func testWhenComponentReadShouldMatchSystemCalendar(component: Calendar.Component) {
            // Arrange
            let base = DateFixtures.referenceDate
            let calendar = DateFixtures.systemCalendar

            // Act
            let result = base[component]

            // Assert
            #expect(result == calendar.component(component, from: base))
        }

        @Test
        func testWhenWeekdayReadShouldBeWithinWeekdayRange() throws {
            // Arrange
            let base = DateFixtures.referenceDate
            let range = TestData.weekdayRange

            // Act
            let result = try #require(base[.weekday])

            // Assert
            #expect(range.contains(result))
        }
    }
}

private enum TestData {
    static let nowTolerance: TimeInterval = 5
    static let additionValue = 3
    static let negativeAdditionValue = -5
    static let zeroValue = 0
    static let positiveStepValue = 1
    static let negativeStepValue = -1
    static let oneSecondInterval: TimeInterval = 1
    static let secondsInDay: TimeInterval = 86_400
    static let daysInWeek = 7
    static let sundayWeekdayNumber = 1
    static let lastUnitInMinute = 59
    static let weekdayRange = 1...7

    static let numericComponents: [Calendar.Component] = [.year, .month, .day, .hour, .minute, .second, .weekday, .era, .quarter, .weekOfMonth, .weekOfYear, .yearForWeekOfYear, .nanosecond]
    static let additionComponents: [Calendar.Component] = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    static let otherDayOffsets: [Int] = [1, -1, 30]
    static let weekComponents: [Calendar.Component] = [.weekOfMonth, .weekOfYear]

    struct TruncatingStartCase: Sendable {
        let component: Calendar.Component
        let base: Date
    }

    static let truncatingStartCases: [TruncatingStartCase] = [
        TruncatingStartCase(component: .second, base: DateFixtures.referenceDate),
        TruncatingStartCase(component: .minute, base: DateFixtures.referenceDate),
        TruncatingStartCase(component: .hour, base: DateFixtures.referenceDate),
        TruncatingStartCase(component: .day, base: DateFixtures.referenceDate),
        TruncatingStartCase(component: .day, base: DateFixtures.endOfYearDate),
        TruncatingStartCase(component: .weekOfYear, base: DateFixtures.midWeekDate),
        TruncatingStartCase(component: .weekOfMonth, base: DateFixtures.midWeekDate)
    ]
}
