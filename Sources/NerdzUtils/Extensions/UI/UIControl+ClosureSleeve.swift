
#if canImport(UIKit)

import UIKit

class ClosureSleeve {
    let closure: ()->()
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    @objc func invoke () {
        closure()
    }
}
public extension UIControl {
    /// Addind target for event by closure
    /// - Parameters:
    ///   - controlEvents: Target control event
    ///   - closure: Closure to execute
    func addAction(for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(ObjectIdentifier(self).hashValue) + String(controlEvents.rawValue), sleeve,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

#endif
