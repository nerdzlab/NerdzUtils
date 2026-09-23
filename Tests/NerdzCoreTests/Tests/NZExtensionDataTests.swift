//
//  NZExtensionDataTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private struct CustomValue: NZExtensionCompatible, Equatable {
    let identifier: Int
}

private enum TestData {

    static let identifier = 17
    static let text = "nerdz"

    static func createCustomValue(identifier: Int = identifier) -> CustomValue {
        CustomValue(identifier: identifier)
    }
}

@Suite("NZ Extension Data")
struct NZExtensionDataTests {

    @Suite("Wrapping")
    struct Wrapping {

        @Test
        func testWhenInitializedWithBaseShouldStoreBase() {
            // Arrange
            let value = TestData.createCustomValue()

            // Act
            let wrapper = NZExtensionData(value)

            // Assert
            #expect(wrapper.base == value)
        }

        @Test
        func testWhenAccessedOnInstanceShouldWrapSameValue() {
            // Arrange
            let value = TestData.createCustomValue()

            // Act
            let wrapper = value.nz

            // Assert
            #expect(wrapper.base == value)
        }

        @Test
        func testWhenAccessedOnStringInstanceShouldWrapSameValue() {
            // Arrange
            let value = TestData.text

            // Act
            let wrapper = value.nz

            // Assert
            #expect(wrapper.base == value)
        }
    }

    @Suite("Static Access")
    struct StaticAccess {

        @Test
        func testWhenAccessedOnTypeShouldReturnExtensionDataType() {
            // Arrange
            let expectedType = NZExtensionData<CustomValue>.self

            // Act
            let type = CustomValue.nz

            // Assert
            #expect(type == expectedType)
        }

        @Test
        func testWhenAccessedOnStringTypeShouldReturnExtensionDataType() {
            // Arrange
            let expectedType = NZExtensionData<String>.self

            // Act
            let type = String.nz

            // Assert
            #expect(type == expectedType)
        }

        @Test
        func testWhenAccessedOnDataTypeShouldReturnExtensionDataType() {
            // Arrange
            let expectedType = NZExtensionData<Data>.self

            // Act
            let type = Data.nz

            // Assert
            #expect(type == expectedType)
        }
    }
}
