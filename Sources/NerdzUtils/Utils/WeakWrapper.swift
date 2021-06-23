import Foundation

/// Adding a possibility of having a weak referance in strong wrapper. 
/// Useful for cases when you need a weak referance for objects in `Array` or `Dictionary
public class Weak<T: AnyObject> {
    
    /// Wrapped object
    public weak var object: T?
    
    /// Initialize wrapper with wrapped object
    /// - Parameter object: Wrapped object
    public init(_ object: T?) {
        self.object = object
    }
}
