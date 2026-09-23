//
//  TaskLongerThanTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private enum TestData {

    static let minimumDelay: TimeInterval = 0.2
    static let shortDelay: TimeInterval = 0.05
    static let longOperationDuration: TimeInterval = 0.3
    static let resultValue = "finished"

    enum SampleError: Error {
        case failed
    }

    static func nanoseconds(from interval: TimeInterval) -> UInt64 {
        UInt64(interval * 1_000_000_000)
    }
}

@Suite("Task Longer Than")
struct TaskLongerThanTests {

    @Test
    func testWhenOperationIsFasterThanDelayShouldFinishAfterDelay() async throws {
        // Arrange
        let delay = TestData.minimumDelay
        let expectedValue = TestData.resultValue

        // Act
        let measurement = try await ElapsedTime.measure {
            try await Task(longerThan: delay) { expectedValue }.value
        }

        // Assert
        #expect(measurement.result == expectedValue)
        #expect(measurement.duration >= delay)
    }

    @Test
    func testWhenOperationIsSlowerThanDelayShouldFinishAfterOperation() async throws {
        // Arrange
        let delay = TestData.shortDelay
        let operationDuration = TestData.longOperationDuration

        // Act
        let measurement = try await ElapsedTime.measure {
            try await Task(longerThan: delay) {
                try await Task.sleep(nanoseconds: TestData.nanoseconds(from: operationDuration))
                return TestData.resultValue
            }
            .value
        }

        // Assert
        #expect(measurement.result == TestData.resultValue)
        #expect(measurement.duration >= operationDuration)
    }

    @Test
    func testWhenOperationThrowsShouldRethrowError() async {
        // Arrange
        let delay = TestData.shortDelay
        let expectedError = TestData.SampleError.failed

        // Act & Assert
        await #expect(throws: expectedError) {
            try await Task(longerThan: delay) { throw expectedError }.value
        }
    }

    @Test
    func testWhenTaskIsCreatedShouldExecuteOperation() async throws {
        // Arrange
        let delay = TestData.shortDelay
        let captor = CallbackCaptor<Void>()

        // Act
        let task = Task(longerThan: delay) {
            captor.record()
        }

        _ = try await task.value

        // Assert
        #expect(captor.count == 1)
    }
}
