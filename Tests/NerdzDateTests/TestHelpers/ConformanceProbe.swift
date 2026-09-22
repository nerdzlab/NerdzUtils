import Foundation
import NerdzCore

enum ConformanceProbe {
    static func isNZExtensionCompatible<T>(_ type: T.Type) -> Bool {
        type is any NZExtensionCompatible.Type
    }
}
