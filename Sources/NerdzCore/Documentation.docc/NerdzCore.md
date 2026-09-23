# ``NerdzCore``

Foundation only helpers that NerdzLab projects share, exposed through the `.nz` namespace.

## Overview

NerdzCore is the base module of the NerdzUtils package. It depends on Foundation alone, so it works
on every platform the package supports, and the other modules (`NerdzDate`, `NerdzUIKit` and
`NerdzKeychain`) build on top of it.

### The nz namespace

Adding members straight onto types such as `String`, `Data` or `Locale` pollutes the global
namespace of those types. Every project that imports the library then sees the extra members in
autocompletion, and two libraries that pick the same member name collide.

NerdzCore avoids that by routing its helpers through a single namespace property. ``NZExtensionData``
is a small generic box that stores the value it was created from in its `base` property, and
``NZExtensionCompatible`` gives any conforming type a `.nz` property (and a `.nz` static property)
that produces such a box. Helpers then live in extensions of ``NZExtensionData`` constrained to the
extended type, which means they are reachable only after `.nz`.

```swift
import NerdzCore

"1.10".nz.isVersion(greaterThan: "1.9")   // true
"  ".nz.isWhiteSpaceOrEmpty               // true
String.nz.overridenLocale = "uk"
```

Conforming a type of your own takes one line, because ``NZExtensionCompatible`` ships a default
implementation of both requirements.

```swift
extension MyModel: NZExtensionCompatible { }

extension NZExtensionData where Base == MyModel {
    var summary: String { "\(base.title) (\(base.id))" }
}
```

Two helpers stay outside the namespace on purpose. `Array` gets a `subscript(safe:)` and `Task`
gets an initializer, because both read better at the call site without a namespace hop.

## Topics

### Essentials

- <doc:GettingStarted>

### The nz namespace

- ``NZExtensionData``
- ``NZExtensionCompatible``

### Collections

- ``Swift/Array/subscript(safe:)``

### Strings

- ``NZExtensionData/isWhiteSpaceOrEmpty``
- ``NZExtensionData/attributed(with:)``
- ``NZExtensionData/localized``
- ``NZExtensionData/overridenLocale``

### Version comparison

- ``NZExtensionData/isVersion(equalTo:)``
- ``NZExtensionData/isVersion(greaterThan:)``
- ``NZExtensionData/isVersion(greaterThanOrEqualTo:)``
- ``NZExtensionData/isVersion(lessThan:)``
- ``NZExtensionData/isVersion(lessThanOrEqualTo:)``

### Codable

- ``NZExtensionData/object(of:)``
- ``NZExtensionData/object()``
- ``UnknownCase``

### Property wrappers

- ``DefaultsProperty``
- ``NullEncodable``

### Concurrency

- ``AtomicAsyncOperation``
- ``DelayedAction``
- ``MinimumAsyncExecutionWrapper``
- ``SyncPropertyActor``
- ``NZExtensionData/once(for:action:)``
- ``NZExtensionData/once(per:token:action:)``
- ``_Concurrency/Task/init(longerThan:operation:)``

### Memory management

- ``Weak``

### Application and locale

- ``NZExtensionData/appVersion``
- ``NZExtensionData/countryList``
- ``NZExtensionData/country(from:)``
- ``NZExtensionData/className-type.property``
- ``NZExtensionData/className-property``
