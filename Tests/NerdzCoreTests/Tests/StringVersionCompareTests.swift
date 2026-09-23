//
//  StringVersionCompareTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private enum TestData {

    static let emptyVersion = ""

    static let greaterPairs = [
        ("1.0.1", "1.0.0"),
        ("2.0.0", "1.9.9"),
        ("1.10.0", "1.9.0"),
        ("1.10", "1.9"),
        ("0.0.2", "0.0.1"),
        ("10.0.0", "9.99.99")
    ]

    static let equalPairs = [
        ("1.0.0", "1.0.0"),
        ("0.0.0", "0.0.0"),
        ("12.34.56", "12.34.56"),
        ("1.01", "1.1")
    ]

    static let equalPairsWithDifferentComponentCount = [
        ("1.2.0", "1.2"),
        ("1.2", "1.2.0"),
        ("1", "1.0.0"),
        ("3.0.0.0", "3"),
        ("1.0.0", "1.0")
    ]

    static let numericallyGreaterPairsWithDifferentComponentCount = [
        ("1.0.1", "1.0"),
        ("1.3", "1.2.5"),
        ("2.0", "1.9.9"),
        ("1.10", "1.9.9"),
        ("1.20", "1.9.9.9")
    ]

    static let versionsGreaterThanEmpty = [
        "0",
        "0.0.0",
        "1.0.0"
    ]
}

@Suite("String Version Compare")
struct StringVersionCompareTests {

    @Suite("Same Component Count")
    struct SameComponentCount {

        @Test(arguments: TestData.greaterPairs)
        func testWhenVersionIsGreaterShouldReportGreaterOrdering(version: String, target: String) {
            // Arrange
            let comparedVersion = version

            // Act
            let isGreater = comparedVersion.nz.isVersion(greaterThan: target)
            let isGreaterOrEqual = comparedVersion.nz.isVersion(greaterThanOrEqualTo: target)
            let isEqual = comparedVersion.nz.isVersion(equalTo: target)
            let isLess = comparedVersion.nz.isVersion(lessThan: target)
            let isLessOrEqual = comparedVersion.nz.isVersion(lessThanOrEqualTo: target)

            // Assert
            #expect(isGreater)
            #expect(isGreaterOrEqual)
            #expect(isEqual == false)
            #expect(isLess == false)
            #expect(isLessOrEqual == false)
        }

        @Test(arguments: TestData.greaterPairs)
        func testWhenVersionIsLowerShouldReportLowerOrdering(target: String, version: String) {
            // Arrange
            let comparedVersion = version

            // Act
            let isLess = comparedVersion.nz.isVersion(lessThan: target)
            let isLessOrEqual = comparedVersion.nz.isVersion(lessThanOrEqualTo: target)
            let isEqual = comparedVersion.nz.isVersion(equalTo: target)
            let isGreater = comparedVersion.nz.isVersion(greaterThan: target)
            let isGreaterOrEqual = comparedVersion.nz.isVersion(greaterThanOrEqualTo: target)

            // Assert
            #expect(isLess)
            #expect(isLessOrEqual)
            #expect(isEqual == false)
            #expect(isGreater == false)
            #expect(isGreaterOrEqual == false)
        }

        @Test(arguments: TestData.equalPairs)
        func testWhenVersionsAreIdenticalShouldReportEqualOrdering(version: String, target: String) {
            // Arrange
            let comparedVersion = version

            // Act
            let isEqual = comparedVersion.nz.isVersion(equalTo: target)
            let isGreaterOrEqual = comparedVersion.nz.isVersion(greaterThanOrEqualTo: target)
            let isLessOrEqual = comparedVersion.nz.isVersion(lessThanOrEqualTo: target)
            let isGreater = comparedVersion.nz.isVersion(greaterThan: target)
            let isLess = comparedVersion.nz.isVersion(lessThan: target)

            // Assert
            #expect(isEqual)
            #expect(isGreaterOrEqual)
            #expect(isLessOrEqual)
            #expect(isGreater == false)
            #expect(isLess == false)
        }
    }

    @Suite("Different Component Count")
    struct DifferentComponentCount {

        @Test(arguments: TestData.equalPairsWithDifferentComponentCount)
        func testWhenMissingComponentsAreZerosShouldReportEqualOrdering(version: String, target: String) {
            // Arrange
            let comparedVersion = version

            // Act
            let isEqual = comparedVersion.nz.isVersion(equalTo: target)
            let isGreaterOrEqual = comparedVersion.nz.isVersion(greaterThanOrEqualTo: target)
            let isLessOrEqual = comparedVersion.nz.isVersion(lessThanOrEqualTo: target)
            let isGreater = comparedVersion.nz.isVersion(greaterThan: target)
            let isLess = comparedVersion.nz.isVersion(lessThan: target)

            // Assert
            #expect(isEqual)
            #expect(isGreaterOrEqual)
            #expect(isLessOrEqual)
            #expect(isGreater == false)
            #expect(isLess == false)
        }

        @Test(arguments: TestData.numericallyGreaterPairsWithDifferentComponentCount)
        func testWhenVersionIsNumericallyGreaterShouldReportGreaterOrdering(version: String, target: String) {
            // Arrange
            let comparedVersion = version

            // Act
            let isGreater = comparedVersion.nz.isVersion(greaterThan: target)
            let isGreaterOrEqual = comparedVersion.nz.isVersion(greaterThanOrEqualTo: target)
            let isEqual = comparedVersion.nz.isVersion(equalTo: target)
            let isLess = comparedVersion.nz.isVersion(lessThan: target)
            let isLessOrEqual = comparedVersion.nz.isVersion(lessThanOrEqualTo: target)

            // Assert
            #expect(isGreater)
            #expect(isGreaterOrEqual)
            #expect(isEqual == false)
            #expect(isLess == false)
            #expect(isLessOrEqual == false)
        }

        @Test(arguments: TestData.numericallyGreaterPairsWithDifferentComponentCount)
        func testWhenVersionIsNumericallyLowerShouldReportLowerOrdering(target: String, version: String) {
            // Arrange
            let comparedVersion = version

            // Act
            let isLess = comparedVersion.nz.isVersion(lessThan: target)
            let isLessOrEqual = comparedVersion.nz.isVersion(lessThanOrEqualTo: target)
            let isEqual = comparedVersion.nz.isVersion(equalTo: target)
            let isGreater = comparedVersion.nz.isVersion(greaterThan: target)
            let isGreaterOrEqual = comparedVersion.nz.isVersion(greaterThanOrEqualTo: target)

            // Assert
            #expect(isLess)
            #expect(isLessOrEqual)
            #expect(isEqual == false)
            #expect(isGreater == false)
            #expect(isGreaterOrEqual == false)
        }
    }

    @Suite("Malformed Input")
    struct MalformedInput {

        @Test
        func testWhenBothVersionsAreEmptyShouldReportEqualOrdering() {
            // Arrange
            let comparedVersion = TestData.emptyVersion

            // Act
            let isEqual = comparedVersion.nz.isVersion(equalTo: comparedVersion)
            let isGreaterOrEqual = comparedVersion.nz.isVersion(greaterThanOrEqualTo: comparedVersion)
            let isLessOrEqual = comparedVersion.nz.isVersion(lessThanOrEqualTo: comparedVersion)
            let isGreater = comparedVersion.nz.isVersion(greaterThan: comparedVersion)
            let isLess = comparedVersion.nz.isVersion(lessThan: comparedVersion)

            // Assert
            #expect(isEqual)
            #expect(isGreaterOrEqual)
            #expect(isLessOrEqual)
            #expect(isGreater == false)
            #expect(isLess == false)
        }

        @Test(arguments: TestData.versionsGreaterThanEmpty)
        func testWhenTargetIsEmptyShouldReportGreaterOrdering(version: String) {
            // Arrange
            let comparedVersion = version
            let target = TestData.emptyVersion

            // Act
            let isGreater = comparedVersion.nz.isVersion(greaterThan: target)
            let isEqual = comparedVersion.nz.isVersion(equalTo: target)
            let isLess = comparedVersion.nz.isVersion(lessThan: target)

            // Assert
            #expect(isGreater)
            #expect(isEqual == false)
            #expect(isLess == false)
        }

        @Test(arguments: TestData.versionsGreaterThanEmpty)
        func testWhenVersionIsEmptyShouldReportLowerOrdering(target: String) {
            // Arrange
            let comparedVersion = TestData.emptyVersion

            // Act
            let isLess = comparedVersion.nz.isVersion(lessThan: target)
            let isEqual = comparedVersion.nz.isVersion(equalTo: target)
            let isGreater = comparedVersion.nz.isVersion(greaterThan: target)

            // Assert
            #expect(isLess)
            #expect(isEqual == false)
            #expect(isGreater == false)
        }
    }
}
