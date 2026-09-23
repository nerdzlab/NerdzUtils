//
//  AtomicAsyncOperationTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private final class ActionController: @unchecked Sendable {

    let invocations = CallbackCaptor<Void>()

    private let lock = NSLock()
    private var storedFinishes: [@Sendable () -> Void] = []
    private var invocationCount = 0

    var count: Int {
        lock.lock()
        defer { lock.unlock() }

        return invocationCount
    }

    func createOperation() -> AtomicAsyncOperation {
        AtomicAsyncOperation { [weak self] finish in
            self?.perform(finish: finish)
        }
    }

    func finishStoredActions() {
        lock.lock()
        let finishes = storedFinishes
        storedFinishes.removeAll()
        lock.unlock()

        DispatchQueue.global().async {
            finishes.forEach { $0() }
        }
    }

    private func perform(finish: @escaping @Sendable () -> Void) {
        lock.lock()
        invocationCount += 1
        let isFirstInvocation = invocationCount == 1

        if isFirstInvocation {
            storedFinishes.append(finish)
        }

        lock.unlock()

        invocations.record()

        if !isFirstInvocation {
            DispatchQueue.global().async(execute: finish)
        }
    }
}

private enum TestData {

    static let concurrentIterations = 20

    static let singleExecutionCount = 1

    static func createController() -> ActionController {
        ActionController()
    }

    static func createSynchronousOperation(invocations: CallbackCaptor<Void>) -> AtomicAsyncOperation {
        AtomicAsyncOperation { finish in
            invocations.record()
            finish()
        }
    }
}

@Suite("Atomic Async Operation")
struct AtomicAsyncOperationTests {

    @Suite("Action Execution")
    struct ActionExecution {

        @Test
        func testWhenOperationIsInitializedShouldNotBeRunning() {
            // Arrange
            let controller = TestData.createController()

            // Act
            let operation = controller.createOperation()

            // Assert
            #expect(operation.isRunning == false)
            #expect(controller.count == 0)
        }

        @Test
        func testWhenPerformIsCalledShouldExecuteAction() async {
            // Arrange
            let controller = TestData.createController()
            let operation = controller.createOperation()

            // Act
            operation.perform()
            await controller.invocations.wait(untilCount: 1)

            // Assert
            #expect(controller.count == 1)
        }

        @Test
        func testWhenActionIsRunningShouldReportIsRunning() async {
            // Arrange
            let controller = TestData.createController()
            let operation = controller.createOperation()

            // Act
            operation.perform()
            await controller.invocations.wait(untilCount: 1)

            // Assert
            #expect(operation.isRunning)
        }

        @Test
        func testWhenActionIsFinishedShouldResetIsRunning() async {
            // Arrange
            let controller = TestData.createController()
            let operation = controller.createOperation()

            operation.perform()
            await controller.invocations.wait(untilCount: 1)

            // Act
            controller.finishStoredActions()

            // Assert
            #expect(await AsyncPoll.wait(until: { operation.isRunning == false }))
        }

        @Test
        func testWhenPerformIsCalledAfterFinishShouldExecuteActionAgain() async {
            // Arrange
            let controller = TestData.createController()
            let operation = controller.createOperation()

            operation.perform()
            await controller.invocations.wait(untilCount: 1)
            controller.finishStoredActions()
            _ = await AsyncPoll.wait(until: { operation.isRunning == false })

            // Act
            operation.perform()
            await controller.invocations.wait(untilCount: 2)

            // Assert
            #expect(controller.count == 2)
        }
    }

    @Suite("Pending Completions")
    struct PendingCompletions {

        @Test
        func testWhenActionIsFinishedShouldCallCompletion() async {
            // Arrange
            let controller = TestData.createController()
            let operation = controller.createOperation()
            let completions = CallbackCaptor<Void>()

            // Act
            operation.perform { completions.record() }
            await controller.invocations.wait(untilCount: 1)
            controller.finishStoredActions()
            await completions.wait(untilCount: 1)

            // Assert
            #expect(completions.count == 1)
        }

        @Test
        func testWhenActionIsRunningShouldNotStartSecondAction() async {
            // Arrange
            let controller = TestData.createController()
            let operation = controller.createOperation()
            let completions = CallbackCaptor<Void>()

            operation.perform { completions.record() }
            await controller.invocations.wait(untilCount: 1)

            // Act
            operation.perform { completions.record() }

            // Assert
            #expect(controller.count == 1)

            controller.finishStoredActions()
            await completions.wait(untilCount: 2)

            #expect(completions.count == 2)
        }

        @Test
        func testWhenActionIsFinishedShouldClearPendingCompletions() async {
            // Arrange
            let controller = TestData.createController()
            let operation = controller.createOperation()
            let completions = CallbackCaptor<Void>()

            operation.perform { completions.record() }
            await controller.invocations.wait(untilCount: 1)
            controller.finishStoredActions()
            await completions.wait(untilCount: 1)

            // Act
            _ = await AsyncPoll.wait(until: { operation.isRunning == false })
            controller.finishStoredActions()

            // Assert
            #expect(await AsyncPoll.wait(until: { completions.count == 1 }))
        }

        @Test
        func testWhenPerformedConcurrentlyShouldRunSingleActionAtATime() async {
            // Arrange
            let controller = TestData.createController()
            let operation = controller.createOperation()
            let completions = CallbackCaptor<Void>()
            let iterations = TestData.concurrentIterations

            // Act
            DispatchQueue.concurrentPerform(iterations: iterations) { _ in
                operation.perform { completions.record() }
            }

            await controller.invocations.wait(untilCount: 1)

            // Assert
            #expect(controller.count == 1)

            controller.finishStoredActions()
            await completions.wait(untilCount: iterations)

            #expect(completions.count == iterations)
        }
    }

    @Suite("Synchronous Action")
    struct SynchronousAction {

        @Test
        func testWhenActionFinishesSynchronouslyShouldCallCompletion() async {
            // Arrange
            let invocations = CallbackCaptor<Void>()
            let operation = TestData.createSynchronousOperation(invocations: invocations)
            let completions = CallbackCaptor<Void>()
            let expectedCount = TestData.singleExecutionCount

            // Act
            operation.perform { completions.record() }

            // Assert
            #expect(await AsyncPoll.wait(until: { completions.count == expectedCount }))
            #expect(invocations.count == expectedCount)
        }

        @Test
        func testWhenActionFinishesSynchronouslyShouldResetIsRunning() async {
            // Arrange
            let invocations = CallbackCaptor<Void>()
            let operation = TestData.createSynchronousOperation(invocations: invocations)

            // Act
            operation.perform()

            // Assert
            #expect(await AsyncPoll.wait(until: { invocations.count == TestData.singleExecutionCount }))
            #expect(await AsyncPoll.wait(until: { operation.isRunning == false }))
        }

        @Test
        func testWhenPerformedConcurrentlyWithSynchronousActionShouldCallEveryCompletion() async {
            // Arrange
            let invocations = CallbackCaptor<Void>()
            let operation = TestData.createSynchronousOperation(invocations: invocations)
            let completions = CallbackCaptor<Void>()
            let iterations = TestData.concurrentIterations

            // Act
            DispatchQueue.concurrentPerform(iterations: iterations) { _ in
                operation.perform { completions.record() }
            }

            // Assert
            #expect(await AsyncPoll.wait(until: { completions.count == iterations }))
        }
    }
}
