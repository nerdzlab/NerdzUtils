import Testing
import Foundation
@testable import NerdzDate

@Suite("Calendar.Component easy use")
struct CalendarComponentEasyUseTests {

    @Suite("Static all components")
    struct StaticAllComponents {

        @Test
        func testWhenStaticListRequestedShouldContainEveryListedComponentOnce() {
            // Arrange
            let expected = TestData.staticComponents

            // Act
            let result = Calendar.Component.nz.allComponents

            // Assert
            #expect(result == expected)
        }

        @Test
        func testWhenStaticListRequestedShouldContainDuplicatedTimeZoneEntry() {
            // Arrange
            let duplicated = TestData.duplicatedComponent

            // Act
            let occurrences = Calendar.Component.nz.allComponents.filter { $0 == duplicated }.count

            // Assert
            #expect(occurrences == TestData.duplicatedComponentOccurrences)
        }

        @Test(arguments: TestData.missingComponents)
        func testWhenStaticListRequestedShouldNotContainUnlistedComponents(component: Calendar.Component) {
            // Arrange
            let all = Calendar.Component.nz.allComponents

            // Act
            let contains = all.contains(component)

            // Assert
            #expect(contains == false)
        }

        @Test
        func testWhenStaticListUsedAsSetShouldDropDuplicates() {
            // Arrange
            let all = Calendar.Component.nz.allComponents

            // Act
            let unique = Set(all)

            // Assert
            #expect(unique.count == all.count - TestData.duplicatedComponentOccurrences + 1)
        }
    }

    @Suite("Included components")
    struct IncludedComponents {

        @Test(arguments: TestData.HierarchyCase.allCases)
        fileprivate func testWhenIncludedComponentsRequestedShouldReturnSmallerUnitsChain(hierarchyCase: TestData.HierarchyCase) {
            // Arrange
            let expected = hierarchyCase.expectedIncludedComponents

            // Act
            let result = hierarchyCase.component.nz.includedComponents

            // Assert
            #expect(result == expected)
        }

        @Test(arguments: TestData.leafComponents)
        func testWhenLeafComponentUsedShouldReturnEmptyChain(component: Calendar.Component) {
            // Arrange
            let expected = TestData.emptyChain

            // Act
            let result = component.nz.includedComponents

            // Assert
            #expect(result == expected)
        }
    }

    @Suite("Instance all components")
    struct InstanceAllComponents {

        @Test(arguments: TestData.HierarchyCase.allCases)
        fileprivate func testWhenAllComponentsRequestedShouldAppendComponentToItsChain(hierarchyCase: TestData.HierarchyCase) {
            // Arrange
            let component = hierarchyCase.component
            let expected = hierarchyCase.expectedIncludedComponents + [component]

            // Act
            let result = component.nz.allComponents

            // Assert
            #expect(result == expected)
        }

        @Test(arguments: TestData.leafComponents)
        func testWhenLeafComponentUsedShouldReturnOnlyItself(component: Calendar.Component) {
            // Arrange
            let expected = [component]

            // Act
            let result = component.nz.allComponents

            // Assert
            #expect(result == expected)
        }
    }
}

private enum TestData {
    static let nanosecondChain: [Calendar.Component] = [.nanosecond]
    static let secondChain: [Calendar.Component] = nanosecondChain + [.second]
    static let minuteChain: [Calendar.Component] = secondChain + [.minute]
    static let hourChain: [Calendar.Component] = minuteChain + [.hour]
    static let dayChain: [Calendar.Component] = hourChain + [.day]
    static let monthChain: [Calendar.Component] = dayChain + [.month]
    static let yearChain: [Calendar.Component] = monthChain + [.year]
    static let weekdayChain: [Calendar.Component] = hourChain + [.weekday]
    static let emptyChain: [Calendar.Component] = []

    static let leafComponents: [Calendar.Component] = [.nanosecond, .calendar, .timeZone]
    static var missingComponents: [Calendar.Component] {
        var components: [Calendar.Component] = [.weekdayOrdinal]

        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            components.append(.isLeapMonth)
        }

        return components
    }
    static let duplicatedComponent: Calendar.Component = .timeZone
    static let duplicatedComponentOccurrences = 2

    static let staticComponents: [Calendar.Component] = [
        .nanosecond,
        .second,
        .minute,
        .hour,
        .day,
        .month,
        .year,
        .era,
        .weekday,
        .quarter,
        .weekOfMonth,
        .weekOfYear,
        .timeZone,
        .yearForWeekOfYear,
        .timeZone,
        .calendar
    ]

    enum HierarchyCase: CaseIterable {
        case era
        case year
        case yearForWeekOfYear
        case quarter
        case month
        case weekOfYear
        case weekOfMonth
        case day
        case weekday
        case weekdayOrdinal
        case hour
        case minute
        case second

        var component: Calendar.Component {
            switch self {
            case .era: return .era
            case .year: return .year
            case .yearForWeekOfYear: return .yearForWeekOfYear
            case .quarter: return .quarter
            case .month: return .month
            case .weekOfYear: return .weekOfYear
            case .weekOfMonth: return .weekOfMonth
            case .day: return .day
            case .weekday: return .weekday
            case .weekdayOrdinal: return .weekdayOrdinal
            case .hour: return .hour
            case .minute: return .minute
            case .second: return .second
            }
        }

        var expectedIncludedComponents: [Calendar.Component] {
            switch self {
            case .era: return yearChain
            case .year, .yearForWeekOfYear, .quarter: return monthChain
            case .month: return dayChain
            case .weekOfYear, .weekOfMonth: return weekdayChain
            case .day, .weekday, .weekdayOrdinal: return hourChain
            case .hour: return minuteChain
            case .minute: return secondChain
            case .second: return nanosecondChain
            }
        }
    }
}
