//
//  DelayedAction.swift
//  NerdzUtils
//
//  Created by new user on 14.04.2021.
//

import Foundation

/// A class that allows to delay some exucution and reinstantiate later if needed
/// Useful 
public class DelayedAction {
    public typealias Action = () -> Void
    
    private var workItem: DispatchWorkItem?
    
    /// Single init
    public init() { }
    
    /// Canceling pending execution
    /// - Returns: Returns `true` if cancel was successful
    @discardableResult public func cancel() -> Bool {
        workItem?.cancel()
        
        return workItem != nil
    }
    
    /// Scheduling execution with a list of parameters
    /// - Parameters:
    ///   - delay: A delay after what action needs to be executed
    ///   - queue: A queue on what 
    ///   - action: An action that needs to be executed
    public func perform(after delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping Action) {
        workItem?.cancel()
        let workItem = DispatchWorkItem(block: action)
        self.workItem = workItem
        
        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}
