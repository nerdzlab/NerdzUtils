//
//  PopoverAvailability.swift
//  NerdzUIKitTests
//

#if os(iOS)

import UIKit

@MainActor
enum PopoverAvailability {

    /// UIKit vends a popover presentation controller for an action sheet only on a regular width
    /// idiom, which varies by device and iOS version, so it is probed once rather than assumed.
    static let isSupported: Bool = {
        UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            .popoverPresentationController != nil
    }()
}

#endif
