//
//  File.swift
//
//
//  Created by new user on 20.04.2020.
//

import Foundation

public extension NZExtensionData where Base: DispatchQueue {

    /// Runs the action once per combination of the given object and token.
    ///
    /// The object is tagged with a private identifier on its first use, and that identifier is
    /// combined with `token` to form the key the execution is remembered under. Two different
    /// objects therefore each run the action once, even when they pass the same token. The
    /// identifier is stored as an associated object, so it lives exactly as long as the object.
    ///
    /// The call is protected by a lock and is safe to make concurrently from several threads. Only
    /// the first caller runs the action, and later calls return without running it again.
    ///
    /// ```swift
    /// DispatchQueue.nz.once(per: self, token: "setup") {
    ///     configure()
    /// }
    /// ```
    ///
    /// - Important: This overload relies on the Objective C runtime and is available only on
    ///   platforms that provide it. It is not available on Linux, where ``once(for:action:)``
    ///   should be used instead.
    ///
    /// - Parameters:
    ///   - object: The object the token is scoped to.
    ///   - token: A key that identifies the action within the scope of `object`.
    ///   - action: The work to run on the first call for this object and token.
    #if canImport(ObjectiveC)
    static func once(per object: AnyObject, token: String, action: () -> Void) {
        let finalToken = OnceStorage.shared.token(for: object) + "." + token
        once(for: finalToken, action: action)
    }
    #endif

    /// Runs the action once per token for the lifetime of the process.
    ///
    /// Executed tokens are kept in a process wide set, so the first call for a given token runs the
    /// action and every later call for the same token returns immediately. The set is guarded by a
    /// lock, which makes the call safe to make concurrently from several threads. The action runs
    /// synchronously on the calling thread.
    ///
    /// ```swift
    /// DispatchQueue.nz.once(for: "analytics.start") {
    ///     Analytics.start()
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - token: A key that identifies the action process wide.
    ///   - action: The work to run on the first call for this token.
    static func once(for token: String, action: () -> Void) {
        OnceStorage.shared.execute(action, onceFor: token)
    }
}

private final class OnceStorage: @unchecked Sendable {

    static let shared = OnceStorage()

    private let tokenAssociationKey = UnsafeRawPointer(UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 1))
    private let lock = NSRecursiveLock()
    private var executedTokens = Set<String>()

    func execute(_ action: () -> Void, onceFor token: String) {
        lock.lock()
        defer { lock.unlock() }

        guard executedTokens.insert(token).inserted else {
            return
        }

        action()
    }

    #if canImport(ObjectiveC)
    func token(for object: AnyObject) -> String {
        lock.lock()
        defer { lock.unlock() }

        if let token = objc_getAssociatedObject(object, tokenAssociationKey) as? String {
            return token
        }

        let token = UUID().uuidString
        objc_setAssociatedObject(
            object,
            tokenAssociationKey,
            token,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )

        return token
    }
    #endif
}
