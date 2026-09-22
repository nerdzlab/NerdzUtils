//
//  AsyncPoll.swift
//  NerdzCoreTests
//

import Foundation

enum AsyncPoll {

    static let defaultTimeout: TimeInterval = 5

    private static let pollInterval: UInt64 = 2_000_000

    static func wait(until condition: () -> Bool, timeout: TimeInterval = defaultTimeout) async -> Bool {
        let deadline = DispatchTime.now().uptimeNanoseconds + UInt64(timeout * 1_000_000_000)

        while DispatchTime.now().uptimeNanoseconds < deadline {
            if condition() {
                return true
            }

            try? await Task.sleep(nanoseconds: pollInterval)
        }

        return condition()
    }
}
