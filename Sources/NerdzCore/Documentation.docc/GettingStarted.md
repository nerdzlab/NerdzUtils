# Getting Started

Add NerdzCore to a project and put the `.nz` namespace to work.

## Overview

`NerdzCore` is the Foundation only product of the NerdzUtils package. Depend on it alone when you
want the namespace, the collection and string helpers, the Codable helpers, the concurrency
utilities and the property wrappers, without linking UIKit or the Keychain dependency.

## Installation

Add the package to `Package.swift` and depend on the `NerdzCore` product.

```swift
let package = Package(
    name: "MyApp",
    dependencies: [
        .package(url: "https://github.com/nerdzlab/NerdzUtils.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "MyApp",
            dependencies: [
                .product(name: "NerdzCore", package: "NerdzUtils")
            ]
        )
    ]
)
```

In Xcode, choose File, then Add Package Dependencies, enter
`https://github.com/nerdzlab/NerdzUtils.git`, and tick `NerdzCore` when Xcode asks which products
to add to your target.

Then import the module where you need it.

```swift
import NerdzCore
```

## Compare version strings correctly

A plain string comparison puts `"1.9"` above `"1.10"`, which breaks force update checks as soon as
a minor version reaches ten. The helpers on the `.nz` namespace split both strings on the dot and
compare the components numerically, treating missing components as zero.

```swift
let installed = Bundle.main.nz.appVersion ?? "0"

if installed.nz.isVersion(lessThan: minimumSupportedVersion) {
    presentForceUpdateScreen()
}

"1.10".nz.isVersion(greaterThan: "1.9")   // true
"1.0".nz.isVersion(equalTo: "1.0.0")      // true
```

See ``NZExtensionData/isVersion(lessThan:)`` and its siblings.

## Run setup code exactly once

``NZExtensionData/once(for:action:)`` keeps a process wide set of tokens and runs the action for the
first caller only. It takes a lock, so several threads may race into it safely.

```swift
func startAnalyticsIfNeeded() {
    DispatchQueue.nz.once(for: "analytics.start") {
        Analytics.configure(with: apiKey)
    }
}
```

When the token should be scoped to one object rather than to the whole process, use
``NZExtensionData/once(per:token:action:)``, which tags the object with a private identifier.
That overload needs the Objective C runtime and is therefore unavailable on Linux.

## Collapse duplicate requests into one

``AtomicAsyncOperation`` runs its action one at a time. Callers that arrive while the action is
running do not start a second run, they are added to the list of completions that fires when the
running action finishes. The action decides when it is done by calling the closure it receives, so
it works for synchronous and asynchronous work alike.

```swift
let refreshToken = AtomicAsyncOperation { finish in
    authService.refresh { _ in
        finish()
    }
}

// Ten simultaneous 401 responses trigger one refresh, and ten retries once it lands.
refreshToken.perform {
    retryRequest()
}
```

## Persist small values without boilerplate

``DefaultsProperty`` stores any `Codable` value in `UserDefaults` as JSON, falling back to the
initial value while nothing is stored. Note that dates are encoded with ISO8601 and lose their sub
second precision on a round trip.

```swift
enum Settings {
    @DefaultsProperty("settings.didOnboard", initial: false)
    static var didOnboard: Bool

    @DefaultsProperty("settings.lastSync", initial: Date.distantPast)
    static var lastSync: Date
}

Settings.didOnboard = true
```

## Debounce repeated work

``DelayedAction`` keeps at most one pending work item. Scheduling again cancels what was pending, so
a search fires once the user stops typing rather than on every keystroke.

```swift
let searchDebouncer = DelayedAction()

func searchFieldDidChange(_ text: String) {
    searchDebouncer.perform(after: 0.3) {
        viewModel.search(text)
    }
}
```

## See Also

- ``NZExtensionCompatible``
- ``SyncPropertyActor``
- ``MinimumAsyncExecutionWrapper``
