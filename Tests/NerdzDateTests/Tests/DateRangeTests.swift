import Testing
import Foundation
@testable import NerdzDate

@Suite("DateRange")
struct DateRangeTests {

    @Suite("Factory methods")
    struct FactoryMethods {

        @Test(arguments: TestData.FactoryCase.allCases)
        fileprivate func testWhenFactoryMethodCalledShouldStoreMatchingComponent(factoryCase: TestData.FactoryCase) {
            // Arrange
            let value = TestData.value

            // Act
            let range = factoryCase.makeRange(value: value)

            // Assert
            #expect(range.component == factoryCase.expectedComponent)
        }

        @Test(arguments: TestData.FactoryCase.allCases)
        fileprivate func testWhenFactoryMethodCalledShouldStorePassedValue(factoryCase: TestData.FactoryCase) {
            // Arrange
            let value = TestData.value

            // Act
            let range = factoryCase.makeRange(value: value)

            // Assert
            #expect(range.value == value)
        }

        @Test(arguments: TestData.FactoryCase.allCases)
        fileprivate func testWhenFactoryMethodCalledWithNegativeValueShouldKeepSign(factoryCase: TestData.FactoryCase) {
            // Arrange
            let value = TestData.negativeValue

            // Act
            let range = factoryCase.makeRange(value: value)

            // Assert
            #expect(range.value == value)
        }
    }

    @Suite("Memberwise initializer")
    struct MemberwiseInitializer {

        @Test
        func testWhenInitializedDirectlyShouldExposeComponentAndValue() {
            // Arrange
            let component = TestData.customComponent
            let value = TestData.value

            // Act
            let range = DateRange(component: component, value: value)

            // Assert
            #expect(range.component == component)
            #expect(range.value == value)
        }

        @Test
        func testWhenUsedForDateAdditionShouldMoveDateByStoredAmount() throws {
            // Arrange
            let value = TestData.value
            let component = TestData.customComponent
            let base = DateFixtures.referenceDate
            let calendar = DateFixtures.systemCalendar

            // Act
            let result = base.nz.adding(DateRange(component: component, value: value))

            // Assert
            #expect(try #require(calendar.dateComponents([component], from: base, to: result).value(for: component)) == value)
        }
    }
}

private enum TestData {
    static let value = 7
    static let negativeValue = -3
    static let customComponent: Calendar.Component = .day

    enum FactoryCase: CaseIterable {
        case second
        case minute
        case hour
        case day
        case weekOfYear
        case weekOfMonth
        case month
        case year

        var expectedComponent: Calendar.Component {
            switch self {
            case .second: return .second
            case .minute: return .minute
            case .hour: return .hour
            case .day: return .day
            case .weekOfYear: return .weekOfYear
            case .weekOfMonth: return .weekOfMonth
            case .month: return .month
            case .year: return .year
            }
        }

        func makeRange(value: Int) -> DateRange {
            switch self {
            case .second: return .second(value)
            case .minute: return .minute(value)
            case .hour: return .hour(value)
            case .day: return .day(value)
            case .weekOfYear: return .weekOfYear(value)
            case .weekOfMonth: return .weekOfMonth(value)
            case .month: return .month(value)
            case .year: return .year(value)
            }
        }
    }
}
