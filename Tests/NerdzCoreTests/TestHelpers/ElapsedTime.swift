//
//  ElapsedTime.swift
//  NerdzCoreTests
//

import Foundation

enum ElapsedTime {

    static func measure<Result>(_ body: () async throws -> Result) async rethrows -> (result: Result, duration: TimeInterval) {
        let start = DispatchTime.now().uptimeNanoseconds
        let result = try await body()
        let duration = TimeInterval(DispatchTime.now().uptimeNanoseconds - start) / 1_000_000_000

        return (result: result, duration: duration)
    }
}
