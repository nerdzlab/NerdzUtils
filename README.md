# NerdzUtils

> Foundation, UIKit, date and Keychain helpers for Apple platforms, split into products you pick from.

[![CI](https://github.com/nerdzlab/NerdzUtils/actions/workflows/ci.yml/badge.svg)](https://github.com/nerdzlab/NerdzUtils/actions/workflows/ci.yml)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20visionOS-lightgrey.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/license-MIT-black.svg)](LICENSE)

Most helpers live behind a `.nz` namespace, so they do not appear on `String`, `Date`, `UIView` or any other type you did not write. You write `"1.2.0".nz.isVersion(greaterThan: "1.1.9")` rather than having `isVersion` show up on every string in your project. A small number of additions are deliberately unnamespaced where the namespace would only add noise, namely the safe `Array` subscript, the `Task` helpers, and the `UnknownCase` protocol.

## Products

The package vends five products. Depend on the ones you need, and you link only what you use.

| Product | Contents | Platforms |
|---|---|---|
| `NerdzCore` | Collections, strings, Codable, concurrency helpers, property wrappers, and the `.nz` namespace itself | all |
| `NerdzDate` | Date arithmetic, unit boundaries, relative formatting, ISO8601 | all |
| `NerdzUIKit` | View, colour, image, alert and controller helpers | iOS |
| `NerdzKeychain` | The `@KeychainProperty` wrapper | all |
| `NerdzUtils` | Umbrella that re-exports the four above | all |

Before 2.0.0 this was a single `NerdzUtils` module, so every consumer linked UIKit and KeychainAccess whether they used them or not. The umbrella exists so that `import NerdzUtils` keeps working unchanged. New code should depend on the specific products instead.

## Requirements

Xcode 15 or later (Swift tools 5.9). Runtime targets are iOS 12, macOS 10.13, tvOS 12, watchOS 4 and visionOS 1. `NerdzUIKit` is iOS only. `NerdzCore` and `NerdzDate` also build on Linux, with one documented exception noted under `once(per:token:action:)`.

## Installation

Add the package:

```swift
dependencies: [
    .package(url: "https://github.com/nerdzlab/NerdzUtils.git", from: "2.0.0")
]
```

Then pick the products your target needs:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "NerdzCore", package: "NerdzUtils"),
        .product(name: "NerdzDate", package: "NerdzUtils"),
        .product(name: "NerdzUIKit", package: "NerdzUtils")
    ]
)
```

Or in Xcode, choose File, Add Package Dependencies, paste the repository URL, and tick the products you want.

## NerdzCore

```swift
import NerdzCore

// Collections
let items = [1, 2, 3]
let missing = items[safe: 5]           // nil instead of a crash

// Strings
"  ".nz.isWhiteSpaceOrEmpty            // true
"welcome_title".nz.localized           // localized lookup
"2.0".nz.isVersion(greaterThan: "1.9.9")   // true
"1.10".nz.isVersion(greaterThan: "1.9")    // true, compared numerically

// Codable
let data = try JSONEncoder().encode(user)
let decoded: User? = try data.nz.object(of: User.self)

// Run something once, from any thread
DispatchQueue.nz.once(for: "migration.v2") {
    runMigration()
}
```

Version comparison splits on dots and compares each component numerically, treating missing components as zero. That is why `"1.10"` is correctly greater than `"1.9"`, where a plain string comparison would disagree.

### Property wrappers

```swift
struct Settings {
    @DefaultsProperty("hasSeenOnboarding", initial: false)
    var hasSeenOnboarding: Bool
}
```

`DefaultsProperty` stores any `Codable` value in `UserDefaults` as JSON. Dates are encoded as ISO8601, so sub second precision is not preserved.

### Concurrency

```swift
// One operation at a time, regardless of how many callers ask
let operation = AtomicAsyncOperation { finish in
    refreshToken { finish() }
}

operation.perform {
    print("done")
}

// Guarantee a minimum on screen duration for a loading state
let result = try await MinimumAsyncExecutionWrapper.run(withMinimumDelay: 0.5) {
    try await api.fetchProfile()
}
```

`AtomicAsyncOperation` works whether the action calls `finish` synchronously or asynchronously. Every completion queued while it runs is called when it finishes.

## NerdzDate

```swift
import NerdzDate

let now = Date()

now.nz.start(of: .month)       // first instant of this month
now.nz.end(of: .year)          // one second before next year starts
now.nz.adding(.day(3))         // date arithmetic through DateRange
now.nz.isInSameDay(as: other)
now.nz.agoString(style: .short)

// ISO8601 decoding that accepts fractional seconds and falls back without them
var decoder = JSONDecoder()
decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.nz.customISO8601
```

Note that `start(of: .weekOfYear)` snaps to Sunday and deliberately ignores the calendar's `firstWeekday`. This is intentional, and it is covered by a test so it does not change by accident.

## NerdzUIKit

```swift
import NerdzUIKit

let brand = UIColor(hex: "#1A73E8")            // optional, nil when the string is not valid hex
let shorthand = UIColor(hex: "FFF")            // white, three digit notation expands
let translucent = UIColor(hex: "1A73E880")     // eight digit notation carries its own alpha
let safe = UIColor.hex("not a colour", fallback: .label)

view.nz.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
view.nz.applyShadow(color: .black, opacity: 0.2, radius: 8)

button.nz.addAction(for: .touchUpInside) {
    print("tapped")
}

parent.nz.easilyAddChild(child)
```

`UIColor(hex:)` is failable. It accepts three, four, six and eight digit notation, with or without a leading `#`, in any case. When the string carries its own alpha, that alpha is used unless you pass one explicitly.

## NerdzKeychain

```swift
import NerdzKeychain

struct Session {
    @KeychainProperty("accessToken", initial: nil)
    var accessToken: String?

    @KeychainProperty("refreshToken", initial: nil, onError: { error in
        logger.error("keychain \(error.operation) failed for \(error.key)")
    })
    var refreshToken: String?
}
```

| Parameter | Meaning |
|---|---|
| `key` | The keychain key |
| `initial` | Returned when nothing is stored, or when a read fails |
| `keychain` | The underlying keychain, defaulting to the main bundle identifier as service |
| `onError` | Called when a read, write or encode fails. Defaults to doing nothing |

Assigning `nil` to an optional property removes the keychain entry. The property then reports its `initial` value. Because `wrappedValue` cannot throw, failures are reported through `onError` rather than silently ignored.

## Migrating from 1.x

Existing code keeps compiling. `import NerdzUtils` re-exports every product, and the old namespace type names remain available as aliases.

The changes that need attention:

```swift
// UIColor(hex:) is now failable.
// Before
let colour = UIColor(hex: "1A73E8")
// After, when you want to handle bad input
let colour = UIColor(hex: "1A73E8") ?? .clear
// After, when you want the old silent fallback
let colour = UIColor.hex("1A73E8")
```

`start(of:)` and `end(of:)` now return correct results for `.month`, `.year`, `.quarter` and `.era`. Before 2.0.0 each landed in the previous unit, so `start(of: .month)` returned the last day of the month before. Any code that compensated for that must drop the compensation.

Version comparison now returns correct results when the two versions have different component counts. Previously `"2.0".nz.isVersion(greaterThan: "1.9.9")` was `false`.

See [CHANGELOG.md](CHANGELOG.md) for the full list.

## Documentation

API reference for `NerdzCore` and `NerdzDate` is published at [nerdzlab.github.io/NerdzUtils](https://nerdzlab.github.io/NerdzUtils/), and is built from the DocC catalogs in this repository.

## License

NerdzUtils is available under the MIT license. See [LICENSE](LICENSE) for details.
