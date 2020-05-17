//
//  ClosureSleeve.swift
//  Mafia
//
//  Created by Volodymyr Khmil on 4/9/20.
//  Copyright © 2020 Mafia. All rights reserved.
//

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
extension UIControl {
    func addAction(for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(ObjectIdentifier(self).hashValue) + String(controlEvents.rawValue), sleeve,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
