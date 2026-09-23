#if os(iOS)

import UIKit
import NerdzCore

@MainActor
final class ClosureSleeve: NSObject {
    typealias ClosureSleezeAction = () -> Void

    let closure: ClosureSleezeAction

    init(_ closure: @escaping ClosureSleezeAction) {
        self.closure = closure
        super.init()
    }

    @objc
    func invoke() {
        closure()
    }
}

@MainActor
private final class ClosureSleeveStorage {
    var sleeves: [ClosureSleeve] = []
}

@MainActor
private let closureSleeveStorageKey = UnsafeRawPointer(UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 1))

@MainActor
public extension NZExtensionData where Base: UIControl {
    /// Addind target for event by closure
    /// - Parameters:
    ///   - controlEvents: Target control event
    ///   - closure: Closure to execute
    func addAction(for controlEvents: UIControl.Event, _ closure: @escaping () -> Void) {
        let sleeve = ClosureSleeve(closure)
        base.addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)

        let storage = objc_getAssociatedObject(base, closureSleeveStorageKey) as? ClosureSleeveStorage
            ?? ClosureSleeveStorage()

        storage.sleeves = storage.sleeves + [sleeve]

        objc_setAssociatedObject(base, closureSleeveStorageKey, storage, .OBJC_ASSOCIATION_RETAIN)
    }
}

#endif
