import Testing
import Foundation
@testable import NerdzDate

@Suite("DateComponents easy use")
struct DateComponentsEasyUseTests {

    @Suite("Reading values")
    struct ReadingValues {

        @Test(arguments: TestData.supportedComponents)
        func testWhenComponentReadShouldMatchValueForComponent(component: Calendar.Component) {
            // Arrange
            let value = TestData.value
            var components = DateComponents()
            components.setValue(value, for: component)

            // Act
            let result = components[component]

            // Assert
            #expect(result == value)
        }

        @Test(arguments: TestData.supportedComponents)
        func testWhenComponentNotSetShouldReturnNil(component: Calendar.Component) {
            // Arrange
            let components = DateComponents()

            // Act
            let result = components[component]

            // Assert
            #expect(result == nil)
        }

        @Test(arguments: TestData.unsupportedComponents)
        func testWhenUnsupportedComponentReadShouldReturnNil(component: Calendar.Component) {
            // Arrange
            let components = DateComponents(year: TestData.value)

            // Act
            let result = components[component]

            // Assert
            #expect(result == nil)
        }
    }

    @Suite("Writing values")
    struct WritingValues {

        @Test(arguments: TestData.supportedComponents)
        func testWhenComponentWrittenShouldBeReadableBack(component: Calendar.Component) {
            // Arrange
            let value = TestData.value
            var components = DateComponents()

            // Act
            components[component] = value

            // Assert
            #expect(components.value(for: component) == value)
        }

        @Test
        func testWhenComponentOverwrittenShouldKeepLatestValue() {
            // Arrange
            let finalValue = TestData.otherValue
            var components = DateComponents()
            components[TestData.writableComponent] = TestData.value

            // Act
            components[TestData.writableComponent] = finalValue

            // Assert
            #expect(components[TestData.writableComponent] == finalValue)
        }

        @Test
        func testWhenComponentSetToNilShouldClearStoredValue() {
            // Arrange
            var components = DateComponents()
            components[TestData.writableComponent] = TestData.value

            // Act
            components[TestData.writableComponent] = nil

            // Assert
            #expect(components[TestData.writableComponent] == nil)
        }

        @Test
        func testWhenCopyMutatedShouldNotAffectOriginalComponents() {
            // Arrange
            let originalValue = TestData.value
            var components = DateComponents()
            components[TestData.writableComponent] = originalValue

            // Act
            var copy = components
            copy[TestData.writableComponent] = TestData.otherValue

            // Assert
            #expect(components[TestData.writableComponent] == originalValue)
        }
    }

    @Suite("Date conversion")
    struct DateConversion {

        @Test
        func testWhenComponentsBuiltThroughSubscriptShouldProduceExpectedDate() throws {
            // Arrange
            let timestamp = DateFixtures.referenceTimestamp
            var calendar = DateFixtures.gregorianCalendar
            calendar.timeZone = try #require(TimeZone(identifier: TestData.utcIdentifier))
            calendar.locale = Locale(identifier: TestData.posixIdentifier)
            let source = calendar.dateComponents(TestData.dateBuildingComponents, from: Date(timeIntervalSince1970: timestamp))

            // Act
            var rebuilt = DateComponents()
            for component in TestData.dateBuildingComponents {
                rebuilt[component] = source[component]
            }

            // Assert
            #expect(try #require(calendar.date(from: rebuilt)) == Date(timeIntervalSince1970: timestamp))
        }
    }
}

private enum TestData {
    static let value = 5
    static let otherValue = 11
    static let writableComponent: Calendar.Component = .day
    static let utcIdentifier = "UTC"
    static let posixIdentifier = "en_US_POSIX"

    static let supportedComponents: [Calendar.Component] = [
        .era,
        .year,
        .month,
        .day,
        .hour,
        .minute,
        .second,
        .nanosecond,
        .weekday,
        .weekdayOrdinal,
        .quarter,
        .weekOfMonth,
        .weekOfYear,
        .yearForWeekOfYear
    ]

    static let unsupportedComponents: [Calendar.Component] = [.calendar, .timeZone]

    static let dateBuildingComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
}
