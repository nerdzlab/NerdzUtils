//
//  Task+LongerThan.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 21.10.2024.
//

import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension Task where Failure == Error {
    @discardableResult
    init(longerThan delay: TimeInterval, operation: @escaping @Sendable () async throws -> Success) {
        self.init {
            try await MinimumAsyncExecutionWrapper.run(withMinimumDelay: delay, action: operation)
        }
    }
}

