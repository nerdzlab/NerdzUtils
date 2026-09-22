import Testing
import Foundation
@testable import NerdzDate

@Suite("Date global time")
struct DateGlobalTimeTests {

    @Suite("Global")
    struct Global {

        @Test(arguments: TestData.dates)
        func testWhenGlobalRequestedShouldSubtractCurrentZoneOffset(base: Date) {
            // Arrange
            let offset = TimeInterval(TimeZone.current.secondsFromGMT(for: base))

            // Act
            let result = base.nz.global

            // Assert
            #expect(result == base.addingTimeInterval(-offset))
        }
    }

    @Suite("Local")
    struct Local {

        @Test(arguments: TestData.dates)
        func testWhenLocalRequestedShouldAddCurrentZoneOffset(base: Date) {
            // Arrange
            let offset = TimeInterval(TimeZone.current.secondsFromGMT(for: base))

            // Act
            let result = base.nz.local

            // Assert
            #expect(result == base.addingTimeInterval(offset))
        }
    }

    @Suite("Symmetry")
    struct Symmetry {

        @Test(arguments: TestData.dates)
        func testWhenBothConversionsAppliedShouldBeSymmetricAroundBase(base: Date) {
            // Arrange
            let global = base.nz.global

            // Act
            let local = base.nz.local

            // Assert
            #expect(local.timeIntervalSince(base) == base.timeIntervalSince(global))
        }

        @Test(arguments: TestData.dates)
        func testWhenBothConversionsAppliedShouldDifferByDoubleZoneOffset(base: Date) {
            // Arrange
            let offset = TimeZone.current.secondsFromGMT(for: base)

            // Act
            let difference = base.nz.local.timeIntervalSince(base.nz.global)

            // Assert
            #expect(difference == TimeInterval(offset * TestData.doublingFactor))
        }
    }
}

private enum TestData {
    static let doublingFactor = 2
    static let dates: [Date] = [DateFixtures.referenceDate, DateFixtures.endOfYearDate, DateFixtures.midWeekDate]
}
