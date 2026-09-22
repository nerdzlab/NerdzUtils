//
//  WeakWrapperTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private final class SampleObject {
    let identifier: Int

    init(identifier: Int) {
        self.identifier = identifier
    }
}

private enum TestData {

    static let identifier = 3
    static let identifiers = [1, 2, 3]

    static func createObject(identifier: Int = identifier) -> SampleObject {
        SampleObject(identifier: identifier)
    }
}

@Suite("Weak Wrapper")
struct WeakWrapperTests {

    @Suite("Object Access")
    struct ObjectAccess {

        @Test
        func testWhenObjectIsAliveShouldReturnSameObject() {
            // Arrange
            let object = TestData.createObject()

            // Act
            let wrapper = Weak(object)

            // Assert
            #expect(wrapper.object === object)
        }

        @Test
        func testWhenInitializedWithNilShouldReturnNil() {
            // Arrange
            let object: SampleObject? = nil

            // Act
            let wrapper = Weak(object)

            // Assert
            #expect(wrapper.object == nil)
        }

        @Test
        func testWhenObjectIsReplacedShouldReturnNewObject() {
            // Arrange
            let firstObject = TestData.createObject()
            let secondObject = TestData.createObject()
            let wrapper = Weak(firstObject)

            // Act
            wrapper.object = secondObject

            // Assert
            #expect(wrapper.object === secondObject)
        }
    }

    @Suite("Object Lifetime")
    struct ObjectLifetime {

        @Test
        func testWhenObjectIsDeallocatedShouldReturnNil() {
            // Arrange
            var object: SampleObject? = TestData.createObject()
            let wrapper = Weak(object)

            // Act
            object = nil

            // Assert
            #expect(wrapper.object == nil)
        }

        @Test
        func testWhenWrapperIsStoredInArrayShouldNotRetainObjects() {
            // Arrange
            var objects: [SampleObject]? = TestData.identifiers.map { TestData.createObject(identifier: $0) }
            let wrappers = (objects ?? []).map { Weak($0) }

            // Act
            objects = nil

            // Assert
            #expect(wrappers.allSatisfy { $0.object == nil })
        }

        @Test
        func testWhenObjectIsAliveShouldKeepIdentifier() {
            // Arrange
            let expectedIdentifier = TestData.identifier
            let object = TestData.createObject(identifier: expectedIdentifier)

            // Act
            let wrapper = Weak(object)

            // Assert
            #expect(wrapper.object?.identifier == expectedIdentifier)
        }
    }
}
