//
//  SyncPropertyActor.swift
//  
//
//  Created by Admin on 21.08.2023.
//

import Foundation

/// An actor that wraps a single value so it can be shared safely across concurrent tasks.
///
/// Use it for a small piece of mutable state, such as a pagination cursor or a cached token, that
/// several tasks read and write. Actor isolation serializes the access, so no external lock is
/// needed. Every access from outside the actor is asynchronous and has to be awaited.
///
/// ```swift
/// let nextPageLink = SyncPropertyActor<String?>(nil)
///
/// await nextPageLink.setNewValue(response.next)
/// let link = await nextPageLink.value
/// ```
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public actor SyncPropertyActor<T> {
    /// The currently stored value.
    ///
    /// Reading it from outside the actor requires `await`. Replacing it from outside is not
    /// possible directly, use ``setNewValue(_:)`` or ``modify(with:)`` instead.
    public var value: T
    
    /// Creates an actor holding the given value.
    ///
    /// - Parameter value: The value to store initially.
    public init(_ value: T) {
        self.value = value
    }
    
    /// Replaces the stored value.
    ///
    /// - Parameter value: The new value to store.
    public func setNewValue(_ value: T) {
        self.value = value
    }
    
    /// Mutates the stored value in place.
    ///
    /// The closure runs while the actor is isolated, so a read and a write that belong together
    /// cannot be interleaved with another task. Prefer it over reading ``value`` and then calling
    /// ``setNewValue(_:)``, because those are two separate hops and another task can change the
    /// value in between.
    ///
    /// ```swift
    /// let counter = SyncPropertyActor(0)
    ///
    /// await counter.modify { $0 += 1 }
    /// ```
    ///
    /// - Parameter closure: A closure that receives the stored value as an `inout` parameter and
    ///   changes it in place.
    public func modify(with closure: (inout T) -> Void) {
        closure(&value)
    }
}
