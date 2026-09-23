//
//  ArraySafeTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private enum TestData {

    static let elements = ["first", "second", "third"]
    static let outOfBoundsIndexes = [-100, -1, 3, 4, 100]
    static let emptyArrayIndexes = [-1, 0, 1]

    static func createArray() -> [String] {
        elements
    }

    static func createEmptyArray() -> [String] {
        []
    }

    static func createOptionalArray() -> [String?] {
        [nil]
    }
}

@Suite("Array Safe Subscript")
struct ArraySafeTests {

    @Suite("Valid Indexes")
    struct ValidIndexes {

        @Test(arguments: TestData.elements.indices)
        func testWhenIndexIsWithinBoundsShouldReturnElement(index: Int) {
            // Arrange
            let array = TestData.createArray()

            // Act
            let element = array[safe: index]

            // Assert
            #expect(element == TestData.elements[index])
        }

        @Test
        func testWhenIndexIsFirstShouldReturnFirstElement() {
            // Arrange
            let array = TestData.createArray()

            // Act
            let element = array[safe: array.startIndex]

            // Assert
            #expect(element == array.first)
        }

        @Test
        func testWhenIndexIsLastShouldReturnLastElement() {
            // Arrange
            let array = TestData.createArray()

            // Act
            let element = array[safe: array.count - 1]

            // Assert
            #expect(element == array.last)
        }

        @Test
        func testWhenArrayContainsOptionalsShouldReturnWrappedElement() {
            // Arrange
            let array = TestData.createOptionalArray()

            // Act
            let element = array[safe: array.count - 1]

            // Assert
            #expect(element == .some(nil))
        }
    }

    @Suite("Invalid Indexes")
    struct InvalidIndexes {

        @Test(arguments: TestData.outOfBoundsIndexes)
        func testWhenIndexIsOutOfBoundsShouldReturnNil(index: Int) {
            // Arrange
            let array = TestData.createArray()

            // Act
            let element = array[safe: index]

            // Assert
            #expect(element == nil)
        }

        @Test
        func testWhenIndexIsEqualToCountShouldReturnNil() {
            // Arrange
            let array = TestData.createArray()

            // Act
            let element = array[safe: array.count]

            // Assert
            #expect(element == nil)
        }

        @Test(arguments: TestData.emptyArrayIndexes)
        func testWhenArrayIsEmptyShouldReturnNil(index: Int) {
            // Arrange
            let array = TestData.createEmptyArray()

            // Act
            let element = array[safe: index]

            // Assert
            #expect(element == nil)
        }
    }
}
