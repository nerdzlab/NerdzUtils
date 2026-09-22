//
//  StringAttributedTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private enum TestData {

    static let text = "Nerdz utils"
    static let emptyText = ""
    static let customKey = NSAttributedString.Key("nz.tests.custom")
    static let secondaryKey = NSAttributedString.Key("nz.tests.secondary")
    static let customValue = "custom-value"
    static let secondaryValue = 42

    static func createAttributes() -> [NSAttributedString.Key: Any] {
        [customKey: customValue]
    }

    static func createMultipleAttributes() -> [NSAttributedString.Key: Any] {
        [customKey: customValue, secondaryKey: secondaryValue]
    }

    static func createEmptyAttributes() -> [NSAttributedString.Key: Any] {
        [:]
    }
}

@Suite("String Attributed")
struct StringAttributedTests {

    @Test
    func testWhenAttributesProvidedShouldPreserveOriginalString() {
        // Arrange
        let text = TestData.text

        // Act
        let attributed = text.nz.attributed(with: TestData.createAttributes())

        // Assert
        #expect(attributed.string == text)
    }

    @Test
    func testWhenAttributesProvidedShouldApplyValue() {
        // Arrange
        let expectedValue = TestData.customValue

        // Act
        let attributed = TestData.text.nz.attributed(with: TestData.createAttributes())

        // Assert
        #expect(attributed.attribute(TestData.customKey, at: 0, effectiveRange: nil) as? String == expectedValue)
    }

    @Test
    func testWhenAttributesProvidedShouldApplyThemToWholeString() {
        // Arrange
        let text = TestData.text
        var effectiveRange = NSRange(location: 0, length: 0)

        // Act
        let attributed = text.nz.attributed(with: TestData.createAttributes())
        _ = attributed.attribute(TestData.customKey, at: 0, effectiveRange: &effectiveRange)

        // Assert
        #expect(effectiveRange == NSRange(location: 0, length: text.utf16.count))
    }

    @Test
    func testWhenMultipleAttributesProvidedShouldApplyAllOfThem() {
        // Arrange
        let expectedStringValue = TestData.customValue
        let expectedNumberValue = TestData.secondaryValue

        // Act
        let attributed = TestData.text.nz.attributed(with: TestData.createMultipleAttributes())
        let attributes = attributed.attributes(at: 0, effectiveRange: nil)

        // Assert
        #expect(attributes[TestData.customKey] as? String == expectedStringValue)
        #expect(attributes[TestData.secondaryKey] as? Int == expectedNumberValue)
    }

    @Test
    func testWhenAttributesAreEmptyShouldReturnStringWithoutAttributes() {
        // Arrange
        let text = TestData.text

        // Act
        let attributed = text.nz.attributed(with: TestData.createEmptyAttributes())

        // Assert
        #expect(attributed.attributes(at: 0, effectiveRange: nil).isEmpty)
        #expect(attributed.string == text)
    }

    @Test
    func testWhenStringIsEmptyShouldReturnEmptyAttributedString() {
        // Arrange
        let text = TestData.emptyText

        // Act
        let attributed = text.nz.attributed(with: TestData.createAttributes())

        // Assert
        #expect(attributed.length == text.utf16.count)
    }
}
