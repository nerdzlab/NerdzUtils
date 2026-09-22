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

/// A class incapsulate a logic of a single operation at a time
/// If operation already in progress - next requests will just be added into completions list that will be called after operation finish
/// This approach decreasing an omount of executions by not running same operation when it's currently initiated by somebody else, and just notifying all requests completions after initial operation finish
/// Useful, for example, when you need to lazy initialize some service when somebody requesting a data. In this case you can guarantee that service will not be initialised twice
/// Or when you want to optimise requests executing.
/// If you save all retrieved data to database - this class might be a good solution to avoid race conditions and unnecessary database storing execution
/// **NOTE**:  Operation is using backeground queue underhood, so wrap all your UI actiong into `main` queue
public class AtomicAsyncOperation: @unchecked Sendable {
    public typealias Action = (@escaping @Sendable () -> Void) -> Void
    public typealias Completion = () -> Void

    /// Executing action
    /// The user of this class is responsible to call back a closure to notify class about Action finishing
    public let action: Action

    /// Specifying if operation is in the process of execution
    public var isRunning: Bool {
        lock.lock()
        defer { lock.unlock() }

        return isExecuting
    }

    private var pendingCompletions: [Completion] = []
    private var isExecuting = false
    private let lock = NSLock()
    private let queue = DispatchQueue(label: "AtomicAsyncOperationQueue", attributes: .concurrent)

    /// Initialize operation with action that needs to be executed
    /// - Parameter action: Execution action
    public init(action: @escaping Action) {
        self.action = action
    }

    /// Performing operation if it is not running yet, or adding into completions list if it is running
    /// - Parameter completion: Completion that needs to be called when execution finished
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
