import Foundation

class Weak<T: AnyObject> {
    weak var object: T?

    init(_ object: T?) {
        self.object = object
    }
}
