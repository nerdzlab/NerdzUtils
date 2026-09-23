//
//  MinimumAsyncExecutionWrapper.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 21.10.2024.
//


import Foundation

/// A helper that keeps asynchronous work on screen for at least a given time.
///
/// It is the implementation behind ``_Concurrency/Task/init(longerThan:operation:)`` and can also
/// be called directly when a task is not what you need.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum MinimumAsyncExecutionWrapper {
    /// Asynchronous work that produces a result of the given type.
    public typealias AsyncAction<Result> = () async throws -> Result
    
    /// Runs the action and returns no earlier than the given delay.
    ///
    /// The action and a sleep of `delay` seconds start at the same time and both are awaited, so
    /// work that finishes sooner than `delay` still takes `delay`, while work that takes longer is
    /// not slowed down. Use it to stop a progress indicator from flashing on screen.
    ///
    /// ```swift
    /// let profile = try await MinimumAsyncExecutionWrapper.run(withMinimumDelay: 0.5) {
    ///     try await loadProfile()
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - delay: The minimum time in seconds the call takes before it returns.
    ///   - action: The asynchronous work to run.
    /// - Returns: The value produced by `action`.
    /// - Throws: Any error thrown by `action`, or a `CancellationError` when the surrounding task
    ///   is cancelled while sleeping.
    @discardableResult
    public static func run<Result>(withMinimumDelay delay: TimeInterval, action: @escaping AsyncAction<Result>) async throws -> Result {
        async let sleepAction: Void = Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        let (value, _) = try await (action(), sleepAction)
        
        return value
    }
}
