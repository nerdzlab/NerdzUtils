//
//  SyncPropertyActorTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private enum TestData {

    static let initialNumber = 5
    static let updatedNumber = 12
    static let initialText = "initial"
    static let updatedText = "updated"
    static let concurrentIterations = 100

    static func createNumberActor(value: Int = initialNumber) -> SyncPropertyActor<Int> {
        SyncPropertyActor(value)
    }

    static func createOptionalTextActor(value: String? = nil) -> SyncPropertyActor<String?> {
        SyncPropertyActor(value)
    }

    static func createArrayActor(value: [Int] = []) -> SyncPropertyActor<[Int]> {
        SyncPropertyActor(value)
    }
}

@Suite("Sync Property Actor")
struct SyncPropertyActorTests {

    @Suite("Value Access")
    struct ValueAccess {

        @Test
        func testWhenInitializedShouldStoreInitialValue() async {
            // Arrange
            let initialValue = TestData.initialNumber

            // Act
            let actor = TestData.createNumberActor(value: initialValue)

            // Assert
            #expect(await actor.value == initialValue)
        }

        @Test
        func testWhenInitializedWithNilShouldStoreNil() async {
            // Arrange
            let actor = TestData.createOptionalTextActor()

            // Act
            let value = await actor.value

            // Assert
            #expect(value == nil)
        }
    }

    @Suite("Value Mutation")
    struct ValueMutation {

        @Test
        func testWhenSetNewValueCalledShouldStoreNewValue() async {
            // Arrange
            let actor = TestData.createNumberActor()
            let newValue = TestData.updatedNumber

            // Act
            await actor.setNewValue(newValue)

            // Assert
            #expect(await actor.value == newValue)
        }

        @Test
        func testWhenSetNewValueCalledWithNilShouldStoreNil() async {
            // Arrange
            let actor = TestData.createOptionalTextActor(value: TestData.initialText)

            // Act
            await actor.setNewValue(nil)

            // Assert
            #expect(await actor.value == nil)
        }

        @Test
        func testWhenModifyCalledShouldApplyClosureToValue() async {
            // Arrange
            let actor = TestData.createOptionalTextActor(value: TestData.initialText)
            let newValue = TestData.updatedText

            // Act
            await actor.modify { $0 = newValue }

            // Assert
            #expect(await actor.value == newValue)
        }

        @Test
        func testWhenModifyCalledOnCollectionShouldMutateInPlace() async {
            // Arrange
            let actor = TestData.createArrayActor()
            let appendedValue = TestData.updatedNumber

            // Act
            await actor.modify { $0.append(appendedValue) }

            // Assert
            #expect(await actor.value == [appendedValue])
        }
    }

    @Suite("Concurrent Access")
    struct ConcurrentAccess {

        @Test
        func testWhenModifiedConcurrentlyShouldApplyEveryMutation() async {
            // Arrange
            let actor = TestData.createNumberActor(value: 0)
            let iterations = TestData.concurrentIterations

            // Act
            await withTaskGroup(of: Void.self) { group in
                for _ in 0..<iterations {
                    group.addTask {
                        await actor.modify { $0 += 1 }
                    }
                }
            }

            // Assert
            #expect(await actor.value == iterations)
        }

        @Test
        func testWhenSetConcurrentlyShouldStoreOneOfProvidedValues() async {
            // Arrange
            let actor = TestData.createNumberActor()
            let firstValue = TestData.initialNumber
            let secondValue = TestData.updatedNumber

            // Act
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await actor.setNewValue(firstValue) }
                group.addTask { await actor.setNewValue(secondValue) }
            }

            // Assert
            #expect([firstValue, secondValue].contains(await actor.value))
        }
    }
}
