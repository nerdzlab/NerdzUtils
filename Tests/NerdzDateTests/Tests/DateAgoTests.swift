import Testing
import Foundation
@testable import NerdzDate

@Suite("Date ago")
struct DateAgoTests {

    @Suite("Style suffixes")
    struct StyleSuffixes {

        @Test(arguments: TestData.ComponentCase.allCases, TestData.StyleCase.allCases)
        fileprivate func testWhenSingularSuffixRequestedShouldMatchStyleTable(
            componentCase: TestData.ComponentCase,
            styleCase: TestData.StyleCase
        ) {
            // Arrange
            let isPlural = TestData.singularFlag

            // Act
            let result = styleCase.style.suffix(for: componentCase.component, isPlural: isPlural)

            // Assert
            #expect(result == styleCase.expectedSuffix(for: componentCase, isPlural: isPlural))
        }

        @Test(arguments: TestData.ComponentCase.allCases, TestData.StyleCase.allCases)
        fileprivate func testWhenPluralSuffixRequestedShouldMatchStyleTable(
            componentCase: TestData.ComponentCase,
            styleCase: TestData.StyleCase
        ) {
            // Arrange
            let isPlural = TestData.pluralFlag

            // Act
            let result = styleCase.style.suffix(for: componentCase.component, isPlural: isPlural)

            // Assert
            #expect(result == styleCase.expectedSuffix(for: componentCase, isPlural: isPlural))
        }

        @Test(arguments: TestData.ComponentCase.allCases)
        fileprivate func testWhenShortStyleUsedShouldIgnorePlurality(componentCase: TestData.ComponentCase) {
            // Arrange
            let style = TestData.StyleCase.short.style

            // Act
            let singular = style.suffix(for: componentCase.component, isPlural: TestData.singularFlag)
            let plural = style.suffix(for: componentCase.component, isPlural: TestData.pluralFlag)

            // Assert
            #expect(singular == plural)
        }

        @Test(arguments: TestData.ComponentCase.allCases)
        fileprivate func testWhenFullStyleUsedShouldPluralizeWithTrailingLetter(componentCase: TestData.ComponentCase) {
            // Arrange
            let style = TestData.StyleCase.full.style

            // Act
            let singular = style.suffix(for: componentCase.component, isPlural: TestData.singularFlag)
            let plural = style.suffix(for: componentCase.component, isPlural: TestData.pluralFlag)

            // Assert
            #expect(plural == singular + TestData.pluralLetter)
        }
    }

    @Suite("Component text")
    struct ComponentText {

        @Test(arguments: TestData.ComponentCase.allCases, TestData.StyleCase.allCases)
        fileprivate func testWhenSingleUnitFormattedShouldUseSingularSuffix(
            componentCase: TestData.ComponentCase,
            styleCase: TestData.StyleCase
        ) {
            // Arrange
            let value = TestData.singularValue

            // Act
            let result = componentCase.component.text(for: value, style: styleCase.style)

            // Assert
            #expect(result == "\(value) \(styleCase.expectedSuffix(for: componentCase, isPlural: TestData.singularFlag))")
        }

        @Test(arguments: TestData.ComponentCase.allCases, TestData.StyleCase.allCases)
        fileprivate func testWhenManyUnitsFormattedShouldUsePluralSuffix(
            componentCase: TestData.ComponentCase,
            styleCase: TestData.StyleCase
        ) {
            // Arrange
            let value = TestData.pluralValue

            // Act
            let result = componentCase.component.text(for: value, style: styleCase.style)

            // Assert
            #expect(result == "\(value) \(styleCase.expectedSuffix(for: componentCase, isPlural: TestData.pluralFlag))")
        }

        @Test(arguments: TestData.ComponentCase.allCases, TestData.StyleCase.allCases)
        fileprivate func testWhenZeroUnitsFormattedShouldUsePluralSuffix(
            componentCase: TestData.ComponentCase,
            styleCase: TestData.StyleCase
        ) {
            // Arrange
            let value = TestData.zeroValue

            // Act
            let result = componentCase.component.text(for: value, style: styleCase.style)

            // Assert
            #expect(result == "\(value) \(styleCase.expectedSuffix(for: componentCase, isPlural: TestData.pluralFlag))")
        }
    }

    @Suite("Ago string")
    struct AgoString {

        @Test(arguments: TestData.intervalCases, TestData.StyleCase.allCases)
        fileprivate func testWhenPastDateFormattedShouldEndWithMatchingUnitSuffix(
            intervalCase: TestData.IntervalCase,
            styleCase: TestData.StyleCase
        ) {
            // Arrange
            let base = Date(timeIntervalSinceNow: intervalCase.offset)

            // Act
            let result = base.nz.agoString(style: styleCase.style)

            // Assert
            #expect(result.hasSuffix(styleCase.expectedSuffix(for: intervalCase.componentCase, isPlural: TestData.pluralFlag) + TestData.agoSuffix))
        }

        @Test(arguments: TestData.absoluteIntervalCases)
        fileprivate func testWhenPastDateFormattedShouldStartWithElapsedAmount(intervalCase: TestData.IntervalCase) {
            // Arrange
            let base = Date(timeIntervalSinceNow: intervalCase.offset)

            // Act
            let result = base.nz.agoString(style: TestData.StyleCase.short.style)

            // Assert
            #expect(result.hasPrefix(String(intervalCase.amount)))
        }

        @Test(arguments: TestData.StyleCase.allCases)
        fileprivate func testWhenFutureDateFormattedShouldReturnJustNow(styleCase: TestData.StyleCase) {
            // Arrange
            let base = Date(timeIntervalSinceNow: TestData.futureOffset)

            // Act
            let result = base.nz.agoString(style: styleCase.style)

            // Assert
            #expect(result == TestData.justNowText)
        }

        @Test(arguments: TestData.StyleCase.allCases)
        fileprivate func testWhenCurrentMomentFormattedShouldReturnJustNow(styleCase: TestData.StyleCase) {
            // Arrange
            let base = Date(timeIntervalSinceNow: TestData.nearFutureOffset)

            // Act
            let result = base.nz.agoString(style: styleCase.style)

            // Assert
            #expect(result == TestData.justNowText)
        }
    }
}

private enum TestData {
    static let singularValue = 1
    static let pluralValue = 5
    static let zeroValue = 0
    static let singularFlag = false
    static let pluralFlag = true
    static let pluralLetter = "s"
    static let agoSuffix = " ago"
    static let justNowText = "Just now"
    static let futureOffset: TimeInterval = 1_000
    static let nearFutureOffset: TimeInterval = 1

    enum ComponentCase: CaseIterable {
        case second
        case minute
        case hour
        case day
        case month
        case year

        var component: TimeAgoComponent {
            switch self {
            case .second: return .second
            case .minute: return .minute
            case .hour: return .hour
            case .day: return .day
            case .month: return .month
            case .year: return .year
            }
        }

        var shortSuffix: String {
            switch self {
            case .second: return "s"
            case .minute: return "m"
            case .hour: return "h"
            case .day: return "d"
            case .month: return "mo"
            case .year: return "y"
            }
        }

        var usesAbsoluteUnit: Bool {
            switch self {
            case .second, .minute: return true
            case .hour, .day, .month, .year: return false
            }
        }

        var fullSingularSuffix: String {
            switch self {
            case .second: return "second"
            case .minute: return "minute"
            case .hour: return "hour"
            case .day: return "day"
            case .month: return "month"
            case .year: return "year"
            }
        }
    }

    enum StyleCase: CaseIterable {
        case short
        case full

        var style: TimeAgoStyle {
            switch self {
            case .short: return .short
            case .full: return .full
            }
        }

        func expectedSuffix(for componentCase: ComponentCase, isPlural: Bool) -> String {
            switch self {
            case .short:
                return componentCase.shortSuffix

            case .full:
                return isPlural ? componentCase.fullSingularSuffix + pluralLetter : componentCase.fullSingularSuffix
            }
        }
    }

    struct IntervalCase: Sendable {
        let componentCase: ComponentCase
        let amount: Int
        let secondsPerUnit: TimeInterval

        var offset: TimeInterval {
            -TimeInterval(amount) * secondsPerUnit
        }
    }

    static let secondsPerSecond: TimeInterval = 1
    static let secondsPerMinute: TimeInterval = 60
    static let secondsPerHour: TimeInterval = 3_600
    static let secondsPerDay: TimeInterval = 86_400
    static let secondsPerRoundedMonth: TimeInterval = 35 * secondsPerDay
    static let secondsPerRoundedYear: TimeInterval = 400 * secondsPerDay

    static let intervalCases: [IntervalCase] = [
        IntervalCase(componentCase: .second, amount: 45, secondsPerUnit: secondsPerSecond),
        IntervalCase(componentCase: .minute, amount: 5, secondsPerUnit: secondsPerMinute),
        IntervalCase(componentCase: .hour, amount: 2, secondsPerUnit: secondsPerHour),
        IntervalCase(componentCase: .day, amount: 3, secondsPerUnit: secondsPerDay),
        IntervalCase(componentCase: .month, amount: 2, secondsPerUnit: secondsPerRoundedMonth),
        IntervalCase(componentCase: .year, amount: 2, secondsPerUnit: secondsPerRoundedYear)
    ]

    static let absoluteIntervalCases: [IntervalCase] = intervalCases.filter { $0.componentCase.usesAbsoluteUnit }
}
