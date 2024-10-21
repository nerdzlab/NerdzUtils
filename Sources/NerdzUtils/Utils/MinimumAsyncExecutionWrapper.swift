//
//  MinimumAsyncExecutionWrapper.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 21.10.2024.
//


import Foundation

public enum MinimumAsyncExecutionWrapper {
    public typealias AsyncAction<Result> = () async throws -> Result
    
    @discardableResult
    public static func run<Result>(withMinimumDelay delay: TimeInterval, action: @escaping AsyncAction<Result>) async throws -> Result {
        async let sleepAction: Void = Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        let (value, _) = try await (action(), sleepAction)
        
        return value
    }
}