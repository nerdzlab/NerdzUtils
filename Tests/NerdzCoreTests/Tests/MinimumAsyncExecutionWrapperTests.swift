//
//  MinimumAsyncExecutionWrapperTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private enum TestData {

    static let minimumDelay: TimeInterval = 0.2
    static let shortDelay: TimeInterval = 0.05
    static let zeroDelay: TimeInterval = 0
    static let longOperationDuration: TimeInterval = 0.3
    static let resultValue = 99

    enum SampleError: Error {
        case failed
    }

    static func nanoseconds(from interval: TimeInterval) -> UInt64 {
        UInt64(interval * 1_000_000_000)
    }
}

@Suite("Minimum Async Execution Wrapper")
struct MinimumAsyncExecutionWrapperTests {

    @Suite("Timing")
    struct Timing {

        @Test
        func testWhenActionIsFasterThanDelayShouldWaitForMinimumDelay() async throws {
            // Arrange
            let delay = TestData.minimumDelay

            // Act
            let measurement = try await ElapsedTime.measure {
                try await MinimumAsyncExecutionWrapper.run(withMinimumDelay: delay) { TestData.resultValue }
            }

            // Assert
            #expect(measurement.duration >= delay)
        }

        @Test
        func testWhenActionIsSlowerThanDelayShouldWaitForAction() async throws {
            // Arrange
            let delay = TestData.shortDelay
            let operationDuration = TestData.longOperationDuration

            // Act
            let measurement = try await ElapsedTime.measure {
                try await MinimumAsyncExecutionWrapper.run(withMinimumDelay: delay) {
                    try await Task.sleep(nanoseconds: TestData.nanoseconds(from: operationDuration))
                    return TestData.resultValue
                }
            }

            // Assert
            #expect(measurement.duration >= operationDuration)
        }

        @Test
        func testWhenDelayIsZeroShouldReturnActionResult() async throws {
            // Arrange
            let expectedValue = TestData.resultValue

            // Act
            let value = try await MinimumAsyncExecutionWrapper.run(withMinimumDelay: TestData.zeroDelay) { expectedValue }

            // Assert
            #expect(value == expectedValue)
        }
    }

    @Suite("Result Delivery")
    struct ResultDelivery {

        @Test
        func testWhenActionReturnsValueShouldReturnSameValue() async throws {
            // Arrange
            let expectedValue = TestData.resultValue

            // Act
            let value = try await MinimumAsyncExecutionWrapper.run(withMinimumDelay: TestData.shortDelay) { expectedValue }

            // Assert
            #expect(value == expectedValue)
        }

        @Test
        func testWhenActionReturnsVoidShouldExecuteAction() async throws {
            // Arrange
            let captor = CallbackCaptor<Void>()

            // Act
            try await MinimumAsyncExecutionWrapper.run(withMinimumDelay: TestData.shortDelay) {
                captor.record()
            }

            // Assert
            #expect(captor.count == 1)
        }

        @Test
        func testWhenActionThrowsShouldPropagateError() async {
            // Arrange
            let expectedError = TestData.SampleError.failed

            // Act & Assert
            await #expect(throws: expectedError) {
                try await MinimumAsyncExecutionWrapper.run(withMinimumDelay: TestData.shortDelay) {
                    throw expectedError
                }
            }
        }
    }
}
