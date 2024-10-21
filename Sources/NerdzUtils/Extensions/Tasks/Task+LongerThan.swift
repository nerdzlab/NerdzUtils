//
//  Task+LongerThan.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 21.10.2024.
//

import Foundation

public extension Task where Failure == Error {
    @discardableResult
    init(longerThan delay: TimeInterval, operation: @escaping @Sendable () async throws -> Success) {
        self.init {
            try await MinimumAsyncExecutionWrapper.run(withMinimumDelay: delay, action: operation)
        }
    }
}

