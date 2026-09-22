//
//  CallbackCaptor.swift
//  NerdzCoreTests
//

import Foundation

final class CallbackCaptor<Value>: @unchecked Sendable {

    private let lock = NSLock()
    private var storage: [Value] = []
    private var waiters: [(target: Int, continuation: CheckedContinuation<Void, Never>)] = []

    var values: [Value] {
        lock.lock()
        defer { lock.unlock() }

        return storage
    }

    var count: Int {
        values.count
    }

    func record(_ value: Value) {
        lock.lock()
        storage.append(value)
        let resumable = waiters.filter { $0.target <= storage.count }
        waiters.removeAll { $0.target <= storage.count }
        lock.unlock()

        resumable.forEach { $0.continuation.resume() }
    }

    func wait(untilCount target: Int) async {
        await withCheckedContinuation { continuation in
            lock.lock()

            if storage.count >= target {
                lock.unlock()
                continuation.resume()
            }
            else {
                waiters.append((target: target, continuation: continuation))
                lock.unlock()
            }
        }
    }
}

extension CallbackCaptor where Value == Void {
    func record() {
        record(())
    }
}
