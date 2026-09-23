# Changelog

All notable changes to NerdzUtils are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0]

This is a major release. The single `NerdzUtils` module is split into four products behind a
compatibility umbrella, the standalone NerdzDate package is folded in, CocoaPods support is
removed, and thirteen defects are fixed. Several of those fixes change observable behavior, so
read Behavior changes before upgrading.

### Breaking changes

- The package now vends `NerdzCore`, `NerdzDate`, `NerdzUIKit`, `NerdzKeychain` and the
  `NerdzUtils` umbrella. `import NerdzUtils` keeps working because the umbrella re-exports all
  four, so existing code compiles unchanged. New code should depend on the specific products.
- The standalone NerdzDate package is discontinued and lives here as the `NerdzDate` product. Its
  consumers change the package URL. A consumer cannot depend on both the old package and this one
  at the same time, because Swift Package Manager rejects two packages vending the same product
  name in one graph.
- `UIColor.init(hex:alpha:)` is now failable and its `alpha` parameter is optional:
  `init?(hex: String, alpha: CGFloat? = nil)`. Use `UIColor.hex(_:alpha:fallback:)` for the
  non optional path.
- `JSONDecoder.DataDecodingStrategy` no longer conforms to `NZExtensionCompatible`. It declared no
  members, so its `.nz` namespace was empty, and the conformance prevented downstream code from
  declaring its own.
- `AtomicAsyncOperation.Action`'s finish closure, `UIViewController.nz.easilyAddChild`'s
  `configurationAction`, the `WindowConfiguratoinAction` typealias and the `LoadableImage.fromUrl`
  completion gain `@Sendable` or `@MainActor`, which Swift 6 requires.
- CocoaPods support is removed. The podspec is deleted.
- `swift-tools-version` moves from 5.2 to 5.9, so building the package requires Xcode 15. Runtime
  deployment targets are unchanged.

### Behavior changes

- `Date.nz.start(of:)` and `end(of:)` returned a date in the previous unit for `.month`, `.year`,
  `.quarter` and `.era`, because the implementation wrote zero into one based calendar fields. For
  example `start(of: .month)` on 2020-09-13 returned 2020-08-31. Both now use
  `Calendar.dateInterval(of:for:)` and return correct results. Code that compensated for the old
  behavior must drop the compensation. The week cases still snap to Sunday and ignore the
  calendar's `firstWeekday`, which is unchanged and covered by a test.
- `String.nz.isVersion(...)` returned inverted results whenever the two versions had a different
  number of components, so `"2.0".nz.isVersion(greaterThan: "1.9.9")` was `false`. Comparison is
  now component wise and numeric, which also fixes double digit components, so `"1.10"` is
  correctly greater than `"1.9"`.
- Assigning `nil` to an optional `KeychainProperty` now removes the keychain entry. Previously it
  stored the string `null`, because `JSONEncoder` encodes a top level `nil` as a valid JSON
  fragment. A property with a non nil `initial` value therefore now reports that initial value
  after a `nil` assignment, where it previously read back as `nil`.
- `Calendar.Component.nz.allComponents` no longer lists `.timeZone` twice and now includes
  `.weekdayOrdinal`, plus `.isLeapMonth` on systems that have it.
- `UIColor(hex:)` no longer returns black for unparseable input. It returns `nil`.

### Fixed

- `DispatchQueue.nz.once` deadlocked when called from more than one thread. It synchronized on a
  Swift metatype, which does not bridge to a stable lock object, so the lock was acquired and never
  released. It now uses a lock held by a dedicated storage type, and a test drives it from many
  threads concurrently.
- `AtomicAsyncOperation` wedged permanently when its action called the finish closure
  synchronously, because the action ran while the semaphore was held and the finish path waited on
  that same semaphore. No completion ever fired. Synchronous and asynchronous actions both work now.
- `JSONDecoder.DateDecodingStrategy.nz.customISO8601` was unreachable. The conformance was declared
  on `DataDecodingStrategy` while the member was declared on `DateDecodingStrategy`, so the symbol
  could not be called at all.
- `UIControl.nz.addAction(for:_:)` left a dangling target. The closure holder was associated with
  the temporary namespace struct rather than the control, under a key that was only valid for the
  duration of the call, so it was released immediately.
- `UIColor(hex:)` ignored the result of its scanner, did not support three digit shorthand, and
  shifted the colour channels for eight digit notation while discarding the embedded alpha.
- Keychain read, write and encode failures were swallowed silently, so a failed write left the
  caller with no signal.
- `DefaultsProperty` used `setValue(_:forKey:)`, which is key value coding rather than the
  `UserDefaults` API.

### Added

- Swift Testing suites for all four products: 278 tests on macOS and 173 on an iOS simulator. Line
  coverage is 98.05% for NerdzCore, 97.88% for NerdzDate and 100% for NerdzKeychain.
- `KeychainPropertyError`, `KeychainPropertyErrorHandler` and an `onError:` parameter on
  `KeychainProperty.init`, so failures are observable. The default handler does nothing, so
  existing call sites are unaffected.
- `UIColor.hex(_:alpha:fallback:)`, plus support for three and four digit shorthand, eight digit
  notation with an embedded alpha, a leading `#`, and surrounding whitespace.
- DocC catalogs for NerdzCore and NerdzDate, published to GitHub Pages on release.
- GitHub Actions CI covering Linux, macOS and an iOS simulator, plus a tag driven release workflow.
- Platform declarations for iOS, macOS, tvOS, watchOS and visionOS, where the package previously
  declared iOS only.
- Rewritten README documenting the product layout, with every snippet compiled against the real API.

### Removed

- The CocoaPods podspec.
- A committed `docs/` directory of generated documentation, its Firebase hosting configuration and
  workflows, the Xcode project, `Package.resolved` and `.swiftpm`.

### Notes

- `NerdzKeychain` cannot build on Linux, because KeychainAccess imports Security. `NerdzCore` and
  `NerdzDate` do build there, with the exception of `DispatchQueue.nz.once(per:token:action:)`,
  which needs the Objective C runtime and is compiled out.
- `Date` values stored through `KeychainProperty` and `DefaultsProperty` are encoded as ISO8601 and
  lose sub second precision. This is unchanged, and it is not corrected here because a decoder
  configured for fractional seconds rejects timestamps that lack them, which would break reading
  values already stored by 1.x.

## [1.1.0]

- Last release of the single module layout.
