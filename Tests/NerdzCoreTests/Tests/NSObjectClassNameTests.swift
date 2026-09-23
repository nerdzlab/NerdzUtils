//
//  NSObjectClassNameTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private class ParentObject: NSObject { }

private final class ChildObject: ParentObject { }

private enum TestData {

    static let parentName = "ParentObject"
    static let childName = "ChildObject"
    static let foundationObjectName = "NSObject"

    static func createParent() -> ParentObject {
        ParentObject()
    }

    static func createChild() -> ChildObject {
        ChildObject()
    }

    static func createUpcastedChild() -> ParentObject {
        ChildObject()
    }
}

@Suite("NSObject Class Name")
struct NSObjectClassNameTests {

    @Suite("Static Access")
    struct StaticAccess {

        @Test
        func testWhenAccessedOnTypeShouldReturnTypeName() {
            // Arrange
            let expectedName = TestData.parentName

            // Act
            let name = ParentObject.nz.className

            // Assert
            #expect(name == expectedName)
        }

        @Test
        func testWhenAccessedOnSubclassTypeShouldReturnSubclassName() {
            // Arrange
            let expectedName = TestData.childName

            // Act
            let name = ChildObject.nz.className

            // Assert
            #expect(name == expectedName)
        }

        @Test
        func testWhenAccessedOnFoundationTypeShouldReturnFoundationName() {
            // Arrange
            let expectedName = TestData.foundationObjectName

            // Act
            let name = NSObject.nz.className

            // Assert
            #expect(name == expectedName)
        }
    }

    @Suite("Instance Access")
    struct InstanceAccess {

        @Test
        func testWhenAccessedOnInstanceShouldReturnClassName() {
            // Arrange
            let object = TestData.createParent()

            // Act
            let name = object.nz.className

            // Assert
            #expect(name == TestData.parentName)
        }

        @Test
        func testWhenAccessedOnSubclassInstanceShouldReturnSubclassName() {
            // Arrange
            let object = TestData.createChild()

            // Act
            let name = object.nz.className

            // Assert
            #expect(name == TestData.childName)
        }

        @Test
        func testWhenInstanceIsUpcastedShouldReturnDynamicClassName() {
            // Arrange
            let object = TestData.createUpcastedChild()

            // Act
            let name = object.nz.className

            // Assert
            #expect(name == TestData.childName)
        }

        @Test
        func testWhenInstanceIsUpcastedShouldDifferFromStaticClassName() {
            // Arrange
            let object = TestData.createUpcastedChild()

            // Act
            let instanceName = object.nz.className
            let staticName = ParentObject.nz.className

            // Assert
            #expect(instanceName != staticName)
        }
    }
}
