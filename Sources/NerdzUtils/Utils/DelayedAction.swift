//
//  DelayedAction.swift
//  NerdzUtils
//
//  Created by new user on 14.04.2021.
//

import Foundation

public class DelayedAction {
    public typealias Action = () -> Void
    
    private var workItem: DispatchWorkItem?
    
    public func perform(after delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping Action) {
        workItem?.cancel()
        let workItem = DispatchWorkItem(block: action)
        self.workItem = workItem
        
        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}
