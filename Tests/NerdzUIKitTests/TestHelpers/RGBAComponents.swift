#if os(iOS)

import UIKit

struct RGBAComponents {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
}

extension RGBAComponents {

    static let maxChannelValue: CGFloat = 255

    init(red8Bit: Int, green8Bit: Int, blue8Bit: Int, alpha: CGFloat) {
        self.init(
            red: CGFloat(red8Bit) / Self.maxChannelValue,
            green: CGFloat(green8Bit) / Self.maxChannelValue,
            blue: CGFloat(blue8Bit) / Self.maxChannelValue,
            alpha: alpha
        )
    }

    init(red8Bit: Int, green8Bit: Int, blue8Bit: Int, alpha8Bit: Int) {
        self.init(
            red8Bit: red8Bit,
            green8Bit: green8Bit,
            blue8Bit: blue8Bit,
            alpha: CGFloat(alpha8Bit) / Self.maxChannelValue
        )
    }

    var inversed: RGBAComponents {
        RGBAComponents(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha)
    }
}

func isClose(_ lhs: RGBAComponents, _ rhs: RGBAComponents, tolerance: CGFloat = Tolerance.component) -> Bool {
    isClose(lhs.red, rhs.red, tolerance: tolerance)
        && isClose(lhs.green, rhs.green, tolerance: tolerance)
        && isClose(lhs.blue, rhs.blue, tolerance: tolerance)
        && isClose(lhs.alpha, rhs.alpha, tolerance: tolerance)
}

extension UIColor {

    var rgbaComponents: RGBAComponents {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return RGBAComponents(red: red, green: green, blue: blue, alpha: alpha)
    }

    static func hexString(red8Bit: Int, green8Bit: Int, blue8Bit: Int, prefixed: Bool) -> String {
        let body = String(format: "%02X%02X%02X", red8Bit, green8Bit, blue8Bit)
        return prefixed ? "#\(body)" : body
    }

    static func hexString(red8Bit: Int, green8Bit: Int, blue8Bit: Int, alpha8Bit: Int, prefixed: Bool) -> String {
        let body = String(format: "%02X%02X%02X%02X", red8Bit, green8Bit, blue8Bit, alpha8Bit)
        return prefixed ? "#\(body)" : body
    }
}

#endif
