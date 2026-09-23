//
//  File.swift
//
//
//  Created by new user on 20.04.2020.
//

import Foundation

public extension NZExtensionData where Base: DispatchQueue {

    /// Execute once per provided token
    /// - Parameters:
    ///   - token: A uniqueue associated with
    ///   - action: Execution acrtion
    #if canImport(ObjectiveC)
    static func once(per object: AnyObject, token: String, action: () -> Void) {
        let finalToken = OnceStorage.shared.token(for: object) + "." + token
        once(for: finalToken, action: action)
    }
    #endif

    /// Execute once per provided token
    /// - Parameters:
    ///   - token: A uniqueue associated with
    ///   - action: Execution acrtion
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
