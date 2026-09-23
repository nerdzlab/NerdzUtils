#if os(iOS)

import Foundation

@MainActor
final class InvocationRecorder {

    private(set) var count = 0

    var wasInvoked: Bool {
        count > 0
    }

    func record() {
        count += 1
    }
}

#endif
