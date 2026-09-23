//
//  DelayedAction.swift
//  NerdzUtils
//
//  Created by new user on 14.04.2021.
//

import Foundation

/// A rescheduling timer for a single piece of delayed work.
///
/// Each call to ``perform(after:queue:action:)`` cancels the work that is still pending, so only
/// the latest scheduled action runs. That makes the type a simple way to debounce input, for
/// example to wait until the user stops typing before starting a search.
///
/// ```swift
/// let search = DelayedAction()
///
/// func textChanged(_ text: String) {
///     search.perform(after: 0.3) {
///         runSearch(text)
///     }
/// }
/// ```
public class DelayedAction {
    /// The work to run after the delay.
    public typealias Action = () -> Void
    
    private var workItem: DispatchWorkItem?
    
    /// Creates an instance with nothing scheduled.
    public init() { }
    
    /// Cancels the pending action, if there is one.
    ///
    /// - Returns: `true` when an action was still pending and has been cancelled, `false` when
    ///   nothing was scheduled or the scheduled action had already run.
    @discardableResult public func cancel() -> Bool {
        guard let workItem else {
            return false
        }

        workItem.cancel()
        self.workItem = nil

        return true
    }
    
    /// Schedules the action, replacing any action that is still pending.
    ///
    /// - Parameters:
    ///   - delay: How long to wait, in seconds, before running the action.
    ///   - queue: The queue the action runs on. Defaults to the main queue.
    ///   - action: The work to run once the delay has passed.
    public func perform(after delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping Action) {
        workItem?.cancel()

        var scheduled: DispatchWorkItem?
        let workItem = DispatchWorkItem { [weak self] in
            action()

            if self?.workItem === scheduled {
                self?.workItem = nil
            }
        }
        scheduled = workItem
        self.workItem = workItem

        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}
