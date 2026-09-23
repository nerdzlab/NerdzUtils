import Foundation

enum DateFixtures {
    static let referenceTimestamp: TimeInterval = 1_600_000_000
    static let fractionOffset: TimeInterval = 0.123
    static let fractionalTimestamp: TimeInterval = referenceTimestamp + fractionOffset
    static let endOfYearTimestamp: TimeInterval = 1_609_459_199
    static let midWeekTimestamp: TimeInterval = 1_600_200_000

    static let referenceDate = Date(timeIntervalSince1970: referenceTimestamp)
    static let endOfYearDate = Date(timeIntervalSince1970: endOfYearTimestamp)
    static let midWeekDate = Date(timeIntervalSince1970: midWeekTimestamp)

    static var systemCalendar: Calendar {
        Calendar.current
    }

    static var gregorianCalendar: Calendar {
        Calendar(identifier: .gregorian)
    }
}
