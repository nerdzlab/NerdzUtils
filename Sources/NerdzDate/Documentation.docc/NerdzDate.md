# ``NerdzDate``

Calendar helpers for `Date`, `DateComponents` and `Calendar.Component`.

## Overview

NerdzDate covers the date work that every app repeats: shifting a date by a calendar amount,
snapping it to the start or the end of a unit, finding the next Monday, rendering a relative
phrase such as `3 days ago`, and reading ISO8601 payloads that sometimes carry milliseconds.

Every helper hangs off the `.nz` namespace that NerdzCore provides, so the Foundation types keep
their own surface clean and autocompletion after `.nz` shows only what this library adds.

```swift
import NerdzDate

let deadline = Date() + .day(7)
let dayStart = deadline.nz.start(of: .day)
let monday = deadline.nz.next(.monday)
let phrase = Date().nz.adding(.hour(-3)).nz.agoString(style: .full)
```

A type joins the namespace by conforming to `NZExtensionCompatible`. NerdzDate adds that
conformance to `Date`, `Calendar.Component` and `JSONDecoder.DateDecodingStrategy`, while
`Formatter` inherits it from the `NSObject` conformance in NerdzCore. Two helpers sit directly on
the Foundation types instead of the namespace, because they are subscripts and operators that
read better without a prefix: `date[.day]`, `components[.day] = 12` and `date + .day(7)`.

All calendar work goes through `Calendar.current`, except the weekday search, which uses a
Gregorian calendar so that the answer does not change with the user's calendar setting.

### Two behaviors worth knowing

``NerdzDate/NerdzCore/NZExtensionData/start(of:)`` and
``NerdzDate/NerdzCore/NZExtensionData/end(of:)`` resolve the unit with
`Calendar.dateInterval(of:for:)`. The start is the first instant of the unit and the end is one
second before the next unit begins. Releases before 2.0.0 computed `.month`, `.year`, `.quarter`
and `.era` incorrectly and landed in the previous unit, so upgrade with that in mind.

The two week units are deliberately different. `.weekOfYear` and `.weekOfMonth` always snap to
Sunday and ignore the calendar's `firstWeekday`, which keeps the result identical in locales where
the week starts on Monday. This is intentional, current behavior.

## Topics

### Essentials

- <doc:GettingStarted>

### Date arithmetic

- ``DateRange``
- ``NerdzDate/NerdzCore/NZExtensionData/adding(_:)``
- ``NerdzDate/Foundation/Date/+(_:_:)``

### Unit boundaries

- ``NerdzDate/NerdzCore/NZExtensionData/start(of:)``
- ``NerdzDate/NerdzCore/NZExtensionData/end(of:)``
- ``NerdzDate/NerdzCore/NZExtensionData/isInSameDay(as:)``

### Weekdays

- ``NerdzDate/NerdzCore/NZExtensionData/Weekday``
- ``NerdzDate/NerdzCore/NZExtensionData/next(_:considerToday:)``
- ``NerdzDate/NerdzCore/NZExtensionData/previous(_:considerToday:)``

### Relative formatting

- ``NerdzDate/NerdzCore/NZExtensionData/agoString(style:)``
- ``TimeAgoStyle``
- ``TimeAgoComponent``

### Calendar components

- ``NerdzDate/NerdzCore/NZExtensionData/allComponents-swift.type.property``
- ``NerdzDate/NerdzCore/NZExtensionData/allComponents-7gx3z``
- ``NerdzDate/NerdzCore/NZExtensionData/includedComponents``
- ``NerdzDate/NerdzCore/NZExtensionData/allComponents-1l2pn``
- ``NerdzDate/Foundation/Date/subscript(_:)``
- ``NerdzDate/Foundation/DateComponents/subscript(_:)``

### Time zone shifting

- ``NerdzDate/NerdzCore/NZExtensionData/global``
- ``NerdzDate/NerdzCore/NZExtensionData/local``

### The current moment

- ``NerdzDate/NerdzCore/NZExtensionData/now``

### ISO8601

- ``NerdzDate/NerdzCore/NZExtensionData/customISO8601``
- ``NerdzDate/NerdzCore/NZExtensionData/iso8601WithFS``
- ``NerdzDate/NerdzCore/NZExtensionData/iso8601``
