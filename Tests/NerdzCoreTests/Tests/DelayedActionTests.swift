//
//  DelayedActionTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private enum TestData {

    static let delay: TimeInterval = 0.15
    static let longDelay: TimeInterval = 5
    static let zeroDelay: TimeInterval = 0
    static let firstIdentifier = "first"
    static let secondIdentifier = "second"

    static func createAction() -> DelayedAction {
        DelayedAction()
    }

    static func createQueue() -> DispatchQueue {
        DispatchQueue(label: "nz.tests.delayed.\(UUID().uuidString)")
    }
}

@Suite("Delayed Action")
struct DelayedActionTests {

    @Suite("Scheduling")
    struct Scheduling {

        @Test
        func testWhenActionIsScheduledShouldExecuteItAfterDelay() async {
            // Arrange
            let action = TestData.createAction()
            let captor = CallbackCaptor<Void>()
            let delay = TestData.delay

            // Act
            let measurement = await ElapsedTime.measure {
                action.perform(after: delay, queue: TestData.createQueue()) {
                    captor.record()
                }

                await captor.wait(untilCount: 1)
            }

            // Assert
            #expect(captor.count == 1)
            #expect(measurement.duration >= delay)
        }

        @Test
        func testWhenActionIsScheduledShouldNotExecuteItImmediately() {
            // Arrange
            let action = TestData.createAction()
            let captor = CallbackCaptor<Void>()

            // Act
            action.perform(after: TestData.longDelay, queue: TestData.createQueue()) {
                captor.record()
            }

            // Assert
            #expect(captor.count == 0)
        }

        @Test
        func testWhenDelayIsZeroShouldExecuteAction() async {
            // Arrange
            let action = TestData.createAction()
            let captor = CallbackCaptor<Void>()

            // Act
            action.perform(after: TestData.zeroDelay, queue: TestData.createQueue()) {
                captor.record()
            }

            await captor.wait(untilCount: 1)

            // Assert
            #expect(captor.count == 1)
        }

        @Test
        func testWhenScheduledOnMainQueueShouldExecuteAction() async {
            // Arrange
            let action = TestData.createAction()
            let captor = CallbackCaptor<Void>()

            // Act
            action.perform(after: TestData.zeroDelay) {
                captor.record()
            }

            await captor.wait(untilCount: 1)

            // Assert
            #expect(captor.count == 1)
        }

        @Test
        func testWhenRescheduledShouldExecuteOnlyLastAction() async {
            // Arrange
            let action = TestData.createAction()
            let captor = CallbackCaptor<String>()
            let firstIdentifier = TestData.firstIdentifier
            let secondIdentifier = TestData.secondIdentifier
            let queue = TestData.createQueue()

            // Act
            action.perform(after: TestData.delay, queue: queue) {
                captor.record(firstIdentifier)
            }

            action.perform(after: TestData.delay, queue: queue) {
                captor.record(secondIdentifier)
            }

            await captor.wait(untilCount: 1)

            // Assert
            #expect(captor.values == [secondIdentifier])
        }
    }

    @Suite("Cancellation")
    struct Cancellation {

        @Test
        func testWhenNothingIsScheduledShouldReturnFalseOnCancel() {
            // Arrange
            let action = TestData.createAction()

            // Act
            let isCancelled = action.cancel()

            // Assert
            #expect(isCancelled == false)
        }

        @Test
        func testWhenActionIsScheduledShouldReturnTrueOnCancel() {
            // Arrange
            let action = TestData.createAction()

            action.perform(after: TestData.longDelay, queue: TestData.createQueue()) { }

            // Act
            let isCancelled = action.cancel()

            // Assert
            #expect(isCancelled)
        }

        @Test
        func testWhenActionIsCancelledShouldNotExecuteIt() async {
            // Arrange
            let action = TestData.createAction()
            let captor = CallbackCaptor<Void>()
            let delay = TestData.delay

            action.perform(after: delay, queue: TestData.createQueue()) {
                captor.record()
            }

            // Act
            action.cancel()

            // Assert
            #expect(await AsyncPoll.wait(until: { captor.count > 0 }, timeout: delay * 3) == false)
        }

        @Test
        func testWhenActionIsExecutedShouldStillReturnTrueOnCancel() async {
            // Arrange
            let action = TestData.createAction()
            let captor = CallbackCaptor<Void>()

            action.perform(after: TestData.zeroDelay, queue: TestData.createQueue()) {
                captor.record()
            }

            await captor.wait(untilCount: 1)

            // Act
            let isCancelled = action.cancel()

            // Assert
            #expect(isCancelled)
        }
    }
}
