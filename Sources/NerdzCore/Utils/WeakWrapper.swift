
import Foundation

/// A strong box that holds its content weakly.
///
/// Collections such as `Array` and `Dictionary` keep strong references to their elements. Store
/// values of this type instead to keep a collection of observers or delegates without extending
/// their lifetime. ``object`` becomes `nil` once the referenced instance is deallocated, so filter
/// the collection when you want the emptied boxes gone.
///
/// ```swift
/// var observers: [Weak<Observer>] = []
///
/// observers.append(Weak(observer))
/// observers = observers.filter { $0.object != nil }
/// ```
public class Weak<T: AnyObject> {
    
    /// The wrapped object, or `nil` once it has been deallocated.
    public weak var object: T?
    
    /// Creates a box around the given object.
    ///
    /// - Parameter object: The object to reference weakly.
    public init(_ object: T?) {
        self.object = object
    }
}
