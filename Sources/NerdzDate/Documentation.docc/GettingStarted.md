# Getting Started

Add NerdzDate to a package and put the `.nz` namespace to work.

## Overview

NerdzDate ships as one of the products of the NerdzUtils package. Depend on the `NerdzDate`
product when date handling is all the target needs. It pulls in `NerdzCore` on its own, because
that is where the `.nz` namespace lives, and it pulls in nothing else.

## Installation

Add the package to `Package.swift`:

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
                .product(name: "NerdzDate", package: "NerdzUtils")
            ]
        )
    ]
)
```

In Xcode, choose File, then Add Package Dependencies, paste the repository URL, and pick the
`NerdzDate` library product. To take every library at once, pick the `NerdzUtils` umbrella
product instead.

Then import the module:

```swift
import NerdzDate
```

## Shifting a date

``DateRange`` describes a signed amount of one calendar unit. Pass it to
``NerdzDate/NerdzCore/NZExtensionData/adding(_:)``, or use the `+` operator when the call site
reads better that way. The arithmetic runs through `Calendar.current`, so it survives daylight
saving transitions and clamps overflowing days.

```swift
let trialEnds = Date() + .day(14)
let lastQuarter = Date().nz.adding(.month(-3))

// 31 January plus one month clamps to the last day of February.
let clamped = januaryThirtyFirst.nz.adding(.month(1))
```

## Snapping to a unit

``NerdzDate/NerdzCore/NZExtensionData/start(of:)`` returns the first instant of the unit that
contains the date, and ``NerdzDate/NerdzCore/NZExtensionData/end(of:)`` returns one second before
the next unit begins. Together they build the closed range a report or a query needs.

```swift
let today = Date()
let dayStart = today.nz.start(of: .day)        // 00:00:00
let dayEnd = today.nz.end(of: .day)            // 23:59:59
let monthStart = today.nz.start(of: .month)    // first day, 00:00:00
let monthEnd = today.nz.end(of: .month)        // last day, 23:59:59
```

`.weekOfYear` and `.weekOfMonth` behave differently on purpose. They always snap to Sunday and
ignore the calendar's `firstWeekday`, so a week runs from Sunday 00:00:00 to Saturday 23:59:59 in
every locale, including the ones where the week starts on Monday.

```swift
let weekStart = today.nz.start(of: .weekOfYear)  // the most recent Sunday, 00:00:00
let weekEnd = today.nz.end(of: .weekOfYear)      // the following Saturday, 23:59:59
```

## Finding a weekday

``NerdzDate/NerdzCore/NZExtensionData/next(_:considerToday:)`` and
``NerdzDate/NerdzCore/NZExtensionData/previous(_:considerToday:)`` search a Gregorian calendar, so
the answer does not depend on the user's calendar setting. A found date is midnight of that day.
Pass `considerToday: true` to accept the date itself when it already falls on the weekday, in
which case the original time of day is kept.

```swift
let nextMonday = Date().nz.next(.monday)
let lastFriday = Date().nz.previous(.friday)
let thisOrNextMonday = Date().nz.next(.monday, considerToday: true)
```

## Decoding ISO8601 payloads

``NerdzDate/NerdzCore/NZExtensionData/customISO8601`` accepts timestamps with fractional seconds
and timestamps without them, which covers backends that only send milliseconds on some fields. A
string that neither format matches raises `DecodingError.dataCorrupted`.

```swift
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .nz.customISO8601

struct Event: Decodable {
    let startsAt: Date
}

// Both of these decode.
let withMilliseconds = try decoder.decode(Event.self, from: Data(#"{"startsAt":"2026-09-23T10:15:30.123Z"}"#.utf8))
let withoutMilliseconds = try decoder.decode(Event.self, from: Data(#"{"startsAt":"2026-09-23T10:15:30Z"}"#.utf8))
```

The formatters behind the strategy are also available on their own as
``NerdzDate/NerdzCore/NZExtensionData/iso8601WithFS`` and
``NerdzDate/NerdzCore/NZExtensionData/iso8601``. They are shared instances, so treat their
`formatOptions` and `timeZone` as read only.

## Rendering a relative phrase

``NerdzDate/NerdzCore/NZExtensionData/agoString(style:)`` picks the largest unit with a value
above zero and renders it in English.

```swift
let short = date.nz.agoString(style: .short)  // "3 d ago"
let full = date.nz.agoString(style: .full)    // "3 days ago"
let recent = Date().nz.agoString(style: .full) // "Just now"
```

On iOS 13 and newer, `RelativeDateTimeFormatter` is the localized alternative. Reach for this
helper when the wording has to stay fixed, or when the deployment target still includes iOS 12.

## See Also

- ``DateRange``
- ``TimeAgoStyle``
