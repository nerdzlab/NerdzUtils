#if os(iOS)

import UIKit

@MainActor
enum TestImageFactory {

    static func image(of size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { context in
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}

#endif
