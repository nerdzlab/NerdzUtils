//
//  Task+LongerThan.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 21.10.2024.
//

import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension Task where Failure == Error {
    /// Creates a task that finishes no earlier than the given delay.
    ///
    /// The operation and a sleep of `delay` seconds start together, and the task finishes once both
    /// are done. An operation that completes faster than `delay` therefore still takes `delay`
    /// seconds, while a slower operation is not held back at all. It is useful for loading
    /// indicators that should not flash on screen. The work is performed by
    /// ``MinimumAsyncExecutionWrapper/run(withMinimumDelay:action:)``.
    ///
    /// ```swift
    /// Task(longerThan: 0.5) {
    ///     try await loadProfile()
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - delay: The minimum time in seconds the task takes before it finishes.
    ///   - operation: The asynchronous work to perform.
    @discardableResult
    init(longerThan delay: TimeInterval, operation: @escaping @Sendable () async throws -> Success) {
        self.init {
            try await MinimumAsyncExecutionWrapper.run(withMinimumDelay: delay, action: operation)
        }
    }
}

