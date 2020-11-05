//
//  AtomicAsyncOperation.swift
//  NerdzUtils
//
//  Created by new user on 04.11.2020.
//

import Foundation

public class AtomicAsyncOperation {
    public typealias Operation = (() -> Void) -> Void
    public typealias Completion = () -> Void
    
    public let operation: Operation
    
    private(set) public var isRunning = false
    
    private var pendingCompletions: [Completion] = []
    private let queue = DispatchQueue(label: "AtomicAsyncOperationQueue")
    
    public init(operation: @escaping Operation) {
        self.operation = operation
    }
    
    public func perform(completion: Completion? = nil) {
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            guard self.isRunning else {
                if let completion = completion {
                    self.pendingCompletions.append(completion)
                }
                
                return
            }
            
            self.isRunning = true
            
            self.operation { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.queue.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    self.pendingCompletions.forEach {  
                        $0()
                    }
                    
                    self.pendingCompletions.removeAll()
                    self.isRunning = false
                }
            }
        }
    }
}
