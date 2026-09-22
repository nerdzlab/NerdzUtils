#if os(iOS)

import CoreGraphics
import Foundation

enum Tolerance {
    static let component: CGFloat = 0.0001
    static let dimension: CGFloat = 0.5
    static let opacity: Float = 0.0001
}

func isClose(_ lhs: CGFloat, _ rhs: CGFloat, tolerance: CGFloat = Tolerance.component) -> Bool {
    abs(lhs - rhs) <= tolerance
}

func isClose(_ lhs: Float, _ rhs: Float, tolerance: Float = Tolerance.opacity) -> Bool {
    abs(lhs - rhs) <= tolerance
}

func isClose(_ lhs: CGSize, _ rhs: CGSize, tolerance: CGFloat = Tolerance.component) -> Bool {
    isClose(lhs.width, rhs.width, tolerance: tolerance) && isClose(lhs.height, rhs.height, tolerance: tolerance)
}

func isClose(_ lhs: CGPoint, _ rhs: CGPoint, tolerance: CGFloat = Tolerance.component) -> Bool {
    isClose(lhs.x, rhs.x, tolerance: tolerance) && isClose(lhs.y, rhs.y, tolerance: tolerance)
}

#endif
