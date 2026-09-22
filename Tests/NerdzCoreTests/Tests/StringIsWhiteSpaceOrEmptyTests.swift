//
//  StringIsWhiteSpaceOrEmptyTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private enum TestData {

    static let blankValues = ["", " ", "   ", "\n", "\t", "\r\n", " \n\t ", "\u{00a0}"]
    static let filledValues = ["a", "0", " a ", "\na\n", ".", "  nerdz  ", "\t-\t"]
}

@Suite("String Is White Space Or Empty")
struct StringIsWhiteSpaceOrEmptyTests {

    @Test(arguments: TestData.blankValues)
    func testWhenStringIsEmptyOrWhitespaceShouldReturnTrue(value: String) {
        // Arrange
        let text = value

        // Act
        let isBlank = text.nz.isWhiteSpaceOrEmpty

        // Assert
        #expect(isBlank)
    }

    @Test(arguments: TestData.filledValues)
    func testWhenStringContainsVisibleCharactersShouldReturnFalse(value: String) {
        // Arrange
        let text = value

        // Act
        let isBlank = text.nz.isWhiteSpaceOrEmpty

        // Assert
        #expect(isBlank == false)
    }
}
