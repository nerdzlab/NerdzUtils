
#if canImport(UIKit)

import UIKit

class ClosureSleeve {
    typealias ClosureSleezeAction = () -> ()
    
    let closure: ClosureSleezeAction
    
    init (_ closure: @escaping ClosureSleezeAction) {
        self.closure = closure
    }
    
    @objc
    func invoke () {
        closure()
    }
}

public extension NZUTilsExtensionData where Base: UIControl {
    /// Addind target for event by closure
    /// - Parameters:
    ///   - controlEvents: Target control event
    ///   - closure: Closure to execute
    func addAction(for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        base.addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(
            self,
            String(ObjectIdentifier(base).hashValue) + String(controlEvents.rawValue),
            sleeve,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }
}

#endif
