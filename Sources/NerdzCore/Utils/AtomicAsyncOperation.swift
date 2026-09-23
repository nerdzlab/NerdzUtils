//
//  AtomicAsyncOperation.swift
//  NerdzUtils
//
//  Created by new user on 04.11.2020.
//

import Foundation

private struct UncheckedSendableBox<Value>: @unchecked Sendable {
    let value: Value
}

/// An operation that runs its action one at a time and notifies every waiting caller when it ends.
///
/// Calling ``perform(completion:)`` while the action is already running does not start a second
/// run. The completion is appended to a list instead, and every collected completion is called once
/// the running action reports that it finished. This collapses a burst of identical requests into a
/// single execution, which suits lazy service initialization, request deduplication or writing a
/// fetched payload to a database only once.
///
/// The action receives a `finish` closure and owns the decision of when to call it, so the action
/// may complete synchronously or asynchronously. Until `finish` is called the operation stays
/// running and keeps collecting completions.
///
/// ```swift
/// let operation = AtomicAsyncOperation { finish in
///     service.load { finish() }
/// }
///
/// operation.perform { print("ready") }
/// operation.perform { print("also ready") }
/// ```
///
/// - Important: The action is started on a private background queue and completions are called on
///   that queue, so dispatch any UI work to the main queue yourself.
public class AtomicAsyncOperation: @unchecked Sendable {
    /// The work performed by the operation, which receives the closure that reports completion.
    public typealias Action = (@escaping @Sendable () -> Void) -> Void

    /// A closure called once the running action has finished.
    public typealias Completion = () -> Void

    /// The work the operation performs.
    ///
    /// The closure it receives must be called when the work is done, otherwise the operation stays
    /// running forever and pending completions are never called.
    public let action: Action

    /// A Boolean value indicating whether the action is currently running.
    ///
    /// It becomes `true` when a first ``perform(completion:)`` call starts the action, and returns
    /// to `false` once the action calls its finish closure.
    public var isRunning: Bool {
        lock.lock()
        defer { lock.unlock() }

        return isExecuting
    }

    private var pendingCompletions: [Completion] = []
    private var isExecuting = false
    private let lock = NSLock()
    private let queue = DispatchQueue(label: "AtomicAsyncOperationQueue", attributes: .concurrent)

    /// Creates an operation around the given action.
    ///
    /// - Parameter action: The work to perform. It must call the closure it receives to report
    ///   that the work is done.
    public init(action: @escaping Action) {
        self.action = action
    }

    /// Starts the action, or joins the run that is already in progress.
    ///
    /// The call returns immediately, because the action is started asynchronously on a background
    /// queue. The completion is called when the current run finishes, whether this call started it
    /// or merely joined it.
    ///
    /// - Parameter completion: The closure called when the run finishes. Pass `nil` to start the
    ///   action without being notified.
    public func perform(completion: Completion? = nil) {
        let completionBox = UncheckedSendableBox(value: completion)

        queue.async { [weak self] in
            self?.start(completion: completionBox.value)
        }
    }

    private func start(completion: Completion?) {
        lock.lock()

        if let completion = completion {
            pendingCompletions.append(completion)
        }

        guard !isExecuting else {
            lock.unlock()
            return
        }

        isExecuting = true
        lock.unlock()

        action { [weak self] in
            self?.finish()
        }
    }

    private func finish() {
        lock.lock()
        let completions = pendingCompletions
        pendingCompletions.removeAll()
        isExecuting = false
        lock.unlock()

        completions.forEach {
            $0()
        }
    }
}
