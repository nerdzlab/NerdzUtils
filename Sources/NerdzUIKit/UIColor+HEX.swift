//
//  UIColor+HEX.swift
//  NerdzUtils
//
//  Created by new user on 31.08.2021.
//

#if os(iOS)

import Foundation
import UIKit

public extension UIColor {

    /// Creates a color from a hexadecimal color notation.
    ///
    /// Supported notations are `RGB`, `RGBA`, `RRGGBB` and `RRGGBBAA`. The string is case insensitive, may be
    /// prefixed with `#` and may be surrounded by whitespace. Shorthand notations are expanded by repeating every
    /// digit, so `"FFF"` is equivalent to `"FFFFFF"` and `"ABC"` to `"AABBCC"`.
    ///
    /// - Parameters:
    ///   - hex: Hexadecimal color notation.
    ///   - alpha: Opacity override. When `nil`, the alpha embedded into `hex` is used, falling back to fully
    ///     opaque for notations that carry no alpha digits. A non-`nil` value always takes precedence over the
    ///     embedded alpha.
    convenience init?(hex: String, alpha: CGFloat? = nil) {
        guard let components = HexColorComponents(hex: hex) else {
            return nil
        }

        self.init(
            red: components.red,
            green: components.green,
            blue: components.blue,
            alpha: alpha ?? components.alpha
        )
    }

    /// Creates a color from a hexadecimal color notation, substituting `fallback` for unparsable input.
    ///
    /// Parsing rules are identical to ``init(hex:alpha:)``.
    ///
    /// - Parameters:
    ///   - hex: Hexadecimal color notation.
    ///   - alpha: Opacity override, taking precedence over the alpha embedded into `hex`.
    ///   - fallback: Color returned when `hex` is not a valid hexadecimal color notation. Defaults to `.black`.
    static func hex(_ hex: String, alpha: CGFloat? = nil, fallback: UIColor = .black) -> UIColor {
        UIColor(hex: hex, alpha: alpha) ?? fallback
    }
}

private struct HexColorComponents {

    private static let hexRadix = 16
    private static let prefix = "#"
    private static let opaqueAlphaDigits = "FF"
    private static let shorthandExpansionFactor = 2
    private static let shorthandRgbLength = 3
    private static let shorthandRgbaLength = 4
    private static let rgbLength = 6
    private static let rgbaLength = 8
    private static let channelBits: UInt64 = 8
    private static let channelMask: UInt64 = 0xFF
    private static let maxChannelValue: CGFloat = 255

    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat

    init?(hex: String) {
        guard let digits = Self.normalizedDigits(from: hex), let value = UInt64(digits, radix: Self.hexRadix) else {
            return nil
        }

        red = Self.channel(of: value, at: 3)
        green = Self.channel(of: value, at: 2)
        blue = Self.channel(of: value, at: 1)
        alpha = Self.channel(of: value, at: 0)
    }

    private static func normalizedDigits(from hex: String) -> String? {
        let trimmed = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let unprefixed = trimmed.hasPrefix(prefix) ? String(trimmed.dropFirst()) : trimmed

        guard unprefixed.allSatisfy({ $0.isASCII && $0.isHexDigit }) else {
            return nil
        }

        switch unprefixed.count {
        case shorthandRgbLength, shorthandRgbaLength:
            let expanded = unprefixed.map({ String(repeating: $0, count: shorthandExpansionFactor) }).joined()
            return expanded.count == rgbLength ? expanded + opaqueAlphaDigits : expanded

        case rgbLength:
            return unprefixed + opaqueAlphaDigits

        case rgbaLength:
            return unprefixed

        default:
            return nil
        }
    }

    private static func channel(of value: UInt64, at index: Int) -> CGFloat {
        CGFloat((value >> (UInt64(index) * channelBits)) & channelMask) / maxChannelValue
    }
}

#endif
