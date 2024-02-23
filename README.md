# NerdzUtils

`NerdzUtils` is a Swift framework designed to simplify and enhance common development tasks by providing a collection of utility classes and extensions. The framework is organized into three main folders:
<br>
<br>
- `Extensions`: This folder extends the functionality of Swift's `Foundation` and `UIKit` frameworks.
    - Foundation: Contains extensions for Foundation framework, adding utility methods and functionalities to Swift's core types.
    - UIKit: Includes extensions for UIKit framework, providing additional functionality to UI components and views.

- `UI Components`: This folder houses custom UI components that can be easily integrated into your iOS projects. The components are designed to enhance user interfaces with features like loadable buttons, loadable image views, etc.

- `Utils`: The Utils folder contains various utility classes that serve as building blocks for common programming patterns. Some of the included classes are SyncPropertyActor, DelayedAction, AtomicAsyncOperation, and more.

<br>

## ***Contents***:

* **Extensions**
    * [**Extensions (Foundation)**](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#--extensions-foundation)
        * [Array](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#arraysafe)
        * [Bundle](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#bundlecurrentversion)
        * [CGSize](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#cgsizedimentions)
        * [Codable](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#unknowncase)
        * [Data](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#datagetobjectfromjsondata)
        * [DataDecodingStrategy](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#datedecodingstrategycustomiso8601)
        * [DispatchQueue](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#dispatchqueueonce)
        * [Encodable](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#encodablejsondata)
        * [Formatter](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#formatteriso8601)
        * [General](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#nzutilsextensiondata)
        * [Locale](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#localecountrylist)
        * [NSObject](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#nsobjectclassname)
        * [String](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#stringattributed)
    * [**Extensions (UIKit)**](https://nerdzlab/NerdzUtils?tab=readme-ov-file#--extensions-uikit)
        * [UIAlertController](https://nerdzlab/NerdzUtils?tab=readme-ov-file#uialertcontrollereasybuild)
        * [UIApplication](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#uiapplicationjailbreak)
        * [UIButton](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#uibuttonlocalized)
        * [UIColor](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#uicolorinversed)
        * [UIControl](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#uicontrolclosuresleeve)
        * [UIImage](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#uiimageblurhash)
        * [UILabel](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#uilabelniblocalized)
        * [UINavigationBar](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#uinavigationbartranslucent)
        * [UITextField](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#uitextfieldlocalized)
        * [UIView](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#uiviewadddashedborder)
        * [UIViewController](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#uiviewcontrolleraddchild)
        * [UIApplication](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#uiapplicationopensettings)
        * [UIColor](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#uicolorhex)
* **[UI Components](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#--ui-components)**
    * [LoadableButton](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#loadablebutton)
    * [LoadableImageView](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#loadableimageview)
    * [SpinnerLoader](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#spinnerloader)
* **[Utils](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#--utils)**
    * **[Property Wrappers](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#--property-wrappers)**
        * [DefaultsProperty](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#defaultsproperty)
        * [KeychainProperty](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#keychainproperty)
        * [NullEncodable](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#nullencodable)
    * [AtomicAsyncOperation](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#atomicasyncoperation)
    * [DelayedAction](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#delayedaction)
    * [IdType](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#idtype)
    * [SyncPropertyActor](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#syncpropertyactor)
    * [WeakWrapper](https://github.com/nerdzlab/NerdzUtils?tab=readme-ov-file#weakwrapper)

<br>

---

# ***- Extensions (Foundation)***
## Array+Safe

The `Array+Safe` extension adds a subscript (`safe`) to the `Array` type, allowing safe access to elements by index. It helps prevent index out-of-range errors by returning `nil` if the requested index is beyond the array bounds.

### Usage

```swift
// Create an array
let myArray = [1, 2, 3, 4, 5]

// Access elements safely using the 'safe' subscript
if let element = myArray[safe: 2] {
    print("Element at index 2: \(element)")
} 
else {
    print("Index 2 is out of range.")
}

// Try accessing an element at an out-of-range index
if let element = myArray[safe: 10] {
    print("Element at index 10: \(element)")
} 
else {
    print("Index 10 is out of range.")
}
```
<br>

---

## Bundle+CurrentAppVersion

The `Bundle+CurrentAppVersion` extension adds a computed property `appVersion` to the `Bundle` type. This property provides a convenient way to retrieve the current application version from the app's `Info.plist` file.

### Usage

```swift
let currentVersion = Bundle.main.appVersion
```
<br>

---

## CGSize+Dimentions

This extension for `CGSize` provides convenient utilities for handling sizes with specific aspect ratios.

### Features

#### Aspect Ratio Sizes

- **w16_h9**: Provides a minimal size with a 16:9 aspect ratio.
- **w9_h16**: Provides a minimal size with a 9:16 aspect ratio.
- **w4_h3**: Provides a minimal size with a 4:3 aspect ratio.
- **w3_h4**: Provides a minimal size with a 3:4 aspect ratio.

#### Scaling

- **scaled(by:)**: Scales the size by a given factor.

### Usage

```swift
// Access aspect ratio sizes
let size16x9 = CGSize.w16_h9
let sizeScaled = CGSize(width: 10, height: 5).scaled(by: 2.0)

// ... (use other aspect ratios and methods as needed)
```
<br>

---

## DateDecodingStrategy+CustomISO8601

The `DateDecodingStrategy+CustomISO8601` extension provides a custom `DateDecodingStrategy` for parsing ISO 8601 dates with fractional seconds.

### Features

- **customISO8601**: A custom date decoding strategy for ISO 8601 dates with fractional seconds.

### Usage

To use the `DateDecodingStrategy+CustomISO8601` extension, follow these steps:

Use the `customISO8601` strategy when configuring your `JSONDecoder` instance to handle ISO 8601 dates with fractional seconds.

```swift
// Create a JSONDecoder with the custom date decoding strategy
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .customISO8601

// Use the decoder to decode JSON containing ISO 8601 dates with fractional seconds
let jsonData = """
{"date": "2024-02-05T12:34:56.789Z"}
""".data(using: .utf8)!

let decodedObject = try decoder.decode(MyObject.self, from: jsonData)
```
<br>

---

## DispatchQueue+Once

The `DispatchQueue+Once` extension provides a mechanism to ensure that a block of code is executed only once, regardless of how many times it is called.

### Features

- **once(per:token:action:)**: Execute a block of code once per provided token associated with an object.
- **once(for:action:)**: Execute a block of code once per provided token.

### Usage

1. **Execute Code Once Per Token**:

   Use the `once(per:token:action:)` method to ensure that a block of code is executed only once per provided token associated with an object.

   ```swift
   private func requestDefaultPermissions() async {
        DispatchQueue.nz.once(per: self, token: permissionsToken) { [weak self] in
            self?.permissionsManager.requestFirstLaunchStartupPermissions()
        }
    }
   ```
   
2. **Execute Code Once Per Token Directly:**

   Alternatively, use the `once(for:action:)` method to execute a block of code once per provided token directly.
   
   ```swift
    DispatchQueue.nz.once(for: "uniqueToken") {
        // Code to be executed once
    }
   ```
<br>

---

## Encodable+JsonData

The `Encodable+JsonData` extension simplifies the process of converting objects conforming to the `Encodable` protocol into JSON data.

### Features

- **nz_jsonData**: Returns JSON data for the given object.

### Usage

```swift
struct MyStruct: Encodable {
    let id: Int
    let title: String
}

let myObject = MyStruct(id: 1, title: "Sample Title")

// Get JSON data from the encodable object
if let jsonData = myObject.nz_jsonData {
    // Use jsonData as needed
    print("JSON Data: \(String(data: jsonData, encoding: .utf8) ?? "Unable to convert to string")")
}
```
<br>

---

## Formatter+iso8601

The `Formatter+iso8601` extension provides ISO8601 date formatters with and without fractional seconds.

### Features

- **iso8601WithFS**: ISO8601 date formatter with fractional seconds.
- **iso8601**: ISO8601 date formatter without fractional seconds.

### Usage

```swift
// Format a date with fractional seconds
let currentDateWithFS = Date()
let formattedWithFS = Formatter.iso8601WithFS.string(from: currentDateWithFS)

// Format a date without fractional seconds
let currentDate = Date()
let formattedWithoutFS = Formatter.iso8601.string(from: currentDate)
```
<br>

---

## `NZUtilsExtensionData`

The `NZUtilsExtensionData` and `NZUtilsExtensionCompatible` provide a foundation for creating Swift extensions with a fluent syntax, allowing you to add utility methods to existing types.

### Features

- **NZUtilsExtensionData**: A wrapper class for extending functionality.
- **NZUtilsExtensionCompatible**: A protocol to make types compatible with NZUtils extensions.

### Usage

#### 1. `NZUtilsExtensionData`

```swift
// Example: Creating an NZUtilsExtensionData wrapper
let myInteger = 42
let wrapper = NZUtilsExtensionData(myInteger)

// Access the base value
let baseValue = wrapper.base // This will be 42
```

#### 2. `NZUtilsExtensionCompatible`

```swift
// Example: Making a type compatible with NZUtils extensions
struct MyStruct:NZUtilsExtensionCompatible {
    var value: String
}

// Use NZUtilsExtensionData for MyStruct
let myInstance = MyStruct(value: "Hello")
let wrappedInstance = myInstance.nz

// Access the base value
let baseValue = wrappedInstance.base // This will be an instance of MyStruct

```
<br>

---

## Locale+CountryList

The `Locale+CountryList` extension provides convenient methods to retrieve a list of countries and obtain details for a specific country based on the current device locale.

### Features

- **countryList**: Returns a list of countries based on the current device locale.
- **country(from:)**: Provides details for a specific country based on its region code.

### Usage

```swift
// Access country list
let countries [Country] = Locale.current.countryList

// Access details for a specific country (e.g., "US")
if let countryDetails = Locale.current.country(from: "US") {
    print("Country Code: \(countryDetails.code), Country Name: \(countryDetails.name)")
}
```
<br>

---

## NSObject+ClassName

The `NSObject+ClassName` extension provides convenient methods to retrieve the class name of an NSObject instance.

### Features

- **className (static)**: Returns the class name of the NSObject class itself.
- **className (instance)**: Returns the class name of the current instance of NSObject.

### Usage

1. **Access Class Name (Static)**:

   ```swift
   // Access class name for MyClass
   let className = MyClass.className
   ```
   
2. **Access Class Name (Instance)**:

   ```swift
   // Create an instance of MyClass
   let myClass = MyClass()

   // Access class name for the instance
   let instanceClassName = myClass.nz.className
   ```
<br>

---

## String+Attributed

The `String+Attributed` extension provides a convenient method to create an attributed string from a `String` with specified attributes.

### Features

- **attributed(with:)**: Forms an attributed string with the given attributes.

### Usage

```swift
let originalString = "Hello, World!"

let attributes: [NSAttributedString.Key: Any] = [
   .font: UIFont.boldSystemFont(ofSize: 16),
   .foregroundColor: UIColor.blue
]

let attributedString = originalString.nz.attributed(with: attributes)
```
<br>

---

## String+IsWhiteSpaceOrEmpty

The `String+IsWhiteSpaceOrEmpty` extension provides a convenient method to check whether a string is empty or consists only of white spaces and new lines.

### Features

- **isWhiteSpaceOrEmpty**: Returns `true` if the string is empty or consists only of white spaces and new lines; otherwise, returns `false`.

### Usage

```swift
let emptyString = ""
let whitespaceString = "     "
let nonEmptyString = "Hello, World!"

let isEmpty = emptyString.nz.isWhiteSpaceOrEmpty // true
let isWhitespace = whitespaceString.nz.isWhiteSpaceOrEmpty // true
let isNonEmpty = nonEmptyString.nz.isWhiteSpaceOrEmpty // false
```
<br>

---

## String+Localization

The `String+Localization` extension provides a convenient method to obtain the localized representation of a string, with support for overriding the current locale.

### Features

- **localized**: Returns the localized representation of the current string.
- **overridenLocale (static)**: Property to set or retrieve an overridden locale for localization.

### Usage

1. **Get Localized String**:

   Use the `localized` property to obtain the localized representation of a string.
   
    ```swift
    let originalString = "hello_key"
    let localizedString = originalString.nz.localized
    ```
    In this example, localizedString will contain the localized representation of the string with the key `"hello_key"`.
    <br>
    
2. **Override Locale**:

   Optionally, use the overridenLocale property to set or retrieve an overridden locale for localization.
   
    ```swift
    originalString.nz.overridenLocale = "fr" // Set to "fr" for French locale
    
    // Access the localized string with the overridden locale
    let frenchLocalizedString = originalString.nz.localized
    ```
    Note: Ensure that the overridden locale is a valid locale identifier (e.g., "fr" for French).
<br>

---
    
## String+VersionCompare

The `String+VersionCompare` extension provides methods to compare string versions to a target version, allowing for easy version comparison in Swift projects.

### Features

- **isVersion(equalTo:)**: Returns `true` if the string version is equal to the target version.
- **isVersion(greaterThan:)**: Returns `true` if the string version is greater than the target version.
- **isVersion(greaterThanOrEqualTo:)**: Returns `true` if the string version is greater than or equal to the target version.
- **isVersion(lessThan:)**: Returns `true` if the string version is less than the target version.
- **isVersion(lessThanOrEqualTo:)**: Returns `true` if the string version is less than or equal to the target version.

### Usage

```swift
// Example: Comparing string versions
let currentVersion = "1.2.3"
let targetVersion = "1.2.0"

let isEqual = currentVersion.nz.isVersion(equalTo: targetVersion) // false
let isGreater = currentVersion.nz.isVersion(greaterThan: targetVersion) // true
let isGreaterOrEqual = currentVersion.nz.isVersion(greaterThanOrEqualTo: targetVersion) // true
let isLess = currentVersion.nz.isVersion(lessThan: targetVersion) // false
let isLessOrEqual = currentVersion.nz.isVersion(lessThanOrEqualTo: targetVersion) // false
```

<br>

---

<br>

# **Extensions (UIKit)**
<br>
<br>

## UIApplication+OpenSettings

The `UIApplication+OpenSettings` extension provides a convenient method to open the native settings of the app on iOS.

### Features

- **openSettings**: Opens the app's native settings.

### Usage

```swift
let application = UIApplication.shared
application.openSettings()
```
<br>

---

# UIApplication+Jailbreak

The `UIApplication+Jailbreak` extension provides a utility method to check whether the current device might be jailbroken.

## Features

- **isJailbroken**: Verifies if the current device might be jailbroken.

## Usage

```swift
let application = UIApplication.shared
let isJailbroken = application.nz.isJailbroken
```
<br>

---

## UIColor+Hex

The `UIColor+Hex` extension provides a convenient initializer to create a `UIColor` instance from a hexadecimal color code.

### Features

- **init(hex: String, alpha: CGFloat)**: Creates a `UIColor` instance from a hexadecimal color code with an optional alpha value.

### Usage

```swift
let hexColor = "#FF5733"
let alphaValue: CGFloat = 1.0

let color = UIColor(hex: hexColor, alpha: alphaValue)
```
<br>

---

## UIAlertController+Extensions

The `UIAlertController+Extensions` provides convenient extensions to streamline the creation and presentation of `UIAlertController` instances in Swift.

### Features

- **action(title:handler:)**: Adds a default action to the alert.
- **destructive(title:handler:)**: Adds a destructive action to the alert.
- **cancel(title:handler:)**: Adds a cancel action to the alert.
- **source(_:)**: Sets up the controller source view for tablets.
- **show(on:)**: Presents the alert on a given controller.

### Usage

```swift
// Example: Creating and presenting an alert
let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)

alertController.nz
   .action(title: "Default Action") {
       // Handle default action
   }
   .destructive(title: "Destructive Action") {
       // Handle destructive action
   }
   .cancel(title: "Cancel Action") {
       // Handle cancel action
   }
   .source(sourceView)
   .show(on: presentingController)
```
<br>

---

## UIButton+Localized

The `UIButton+Localized` extension provides a convenient way to set localized text for `UIButton` instances, especially useful when working with nib files.

### Features

- **textLocalization**: Sets the localized text for a button.
- **nz_textLocalization**: An `@IBInspectable` property for setting localized text directly in Interface Builder.

### Usage

1. **Set Localized Text Programmatically**:

   ```swift
   let button = UIButton(type: .system)
   button.nz.textLocalization = "buttonTitleKey"
   ```
   
2. **Set Localized Text in Interface Builder**:

    Use the @IBInspectable property nz_textLocalization to set localized text directly in Interface Builder.
   
    ![Screenshot 2024-02-16 at 15 50 23](https://github.com/nerdzlab/NerdzUtils/assets/37474736/efc2448a-b159-4db1-98a3-58acbd3ebb9b)
<br>

---

## UIColor+Inversed

The `UIColor+Inversed` extension provides a simple way to obtain the inverse color of a given `UIColor`. This can be useful for creating visually contrasting elements in your app.

## Features

- **inversed**: Computes and returns the inverse color of the current color.

## Usage

1. **Compute Inverse Color Programmatically**:

    ```swift
    let originalColor = UIColor.red
    let inverseColor = originalColor.nz.inversed
    ```

2. **Apply Inverse Color in UI Elements**:
 
    ```swift
    let originalColor = UIColor.blue
    let inverseColor = originalColor.nz.inversed
    
    let myView = UIView()
    myView.backgroundColor = originalColor // Set the original color
    // ...
    // Apply the inverse color to another UI element
    someOtherElement.backgroundColor = inverseColor
    ```
<br>

---

## UIControl+ClosureAction

The `UIControl+ClosureAction` extension allows you to easily add closure-based actions to a `UIControl`. This provides a more concise and expressive way to handle control events.

### Features

- **addAction(for:closure:)**: Adds a closure-based action for a specific control event.

### Usage

1. **Add Closure-Based Action**:

   ```swift
   let myButton = UIButton()

   myButton.nz.addAction(for: .touchUpInside) {
       print("Button tapped!")
   }
   ```

2. **Handle Control Events with Closures**:

    ```swift
    let mySwitch = UISwitch()

    mySwitch.nz.addAction(for: .valueChanged) {
        print("Switch value changed!")
    }
    ```
<br>

---

## UIImage+BlurHash

The `UIImage+BlurHash` extension provides an easy way to initialize a `UIImage` using the BlurHash algorithm. BlurHash is a compact representation of a placeholder for an image, useful for lazy loading images with a placeholder effect.

### Features

- **Initialization from BlurHash**: Initialize a `UIImage` using the BlurHash algorithm, providing hash information including the BlurHash string, rendering size, and punch.

### Usage

```swift
let blurHashInfo = BlurHashInfo(
    hash: "LEHV6nWB2yk8pyo0adR*.7kCMdnj", 
    size: CGSize(width: 320, height: 240)
)

if let blurredImage = UIImage(info: blurHashInfo) {
   // Use the blurredImage as a placeholder or background
}
```
<br>

---

## UIImage+Scale

The `UIImage+Scale` extension provides convenient methods for scaling `UIImage` objects based on width, height, or custom size requirements.

### Features

- **Scaling by Width**: Scale an image to a specific width.
- **Scaling by Height**: Scale an image to a specific height.
- **Scaling to Bigger Side**: Scale an image to a specified size for the bigger side.
- **Scaling to Smaller Side**: Scale an image to a specified size for the smaller side.
- **Scaling to Fit Size**: Scale an image to fit within a target size while maintaining the aspect ratio.
- **Scaling by Factor**: Scale an image by a provided factor.

### Usage

1. **Scale Image by Width/Height**:

   Use the `scaled(toWidth:)`/`scaled(toHeight:)` method to scale an image to a specific width/height.

   ```swift
   let originalImage: UIImage = // Some image
   let scaledByWidthImage = originalImage.nz.scaled(toWidth: 200)
   let scaledByHeightImage = originalImage.nz.scaled(toHeight: 150)
   ```

2. **Scale Image to Bigger Side/Smaller Side**:

   Use the `scaled(toBigger:)`/`scaled(toSmaller:)` method to scale an image to a specified size for the bigger/smaller side.

   ```swift
   let originalImage: UIImage = // Some image
   let scaledToBiggerSideImage = originalImage.nz.scaled(toBigger: 300)
   let scaledToSmallerSideImage = originalImage.nz.scaled(toSmaller: 120)
   ```

3. **Scale Image to Fit Size**:

   Use the scaled(toFit:) method to scale an image to fit within a target size while maintaining the aspect ratio.
   
   ```swift
   let originalImage: UIImage = // Some image
   let targetSize = CGSize(width: 250, height: 200)
   let scaledImage = originalImage.nz.scaled(toFit: targetSize)
   ```
   
4. **Scale Image by Factor**:

    Use the scaled(by:) method to scale an image by a provided factor.

   ```swift
   let originalImage: UIImage = // Some image
   let scaledImage = originalImage.nz.scaled(by: 1.5)
   ```
<br>

---

## UILabel+NibLocalized

The `UILabel+NibLocalized` extension provides a convenient way to set localized text for `UILabel` elements directly from `.nib` files.

### Features

- **Localized Text**: Set localized text for a `UILabel` from a `.nib` file effortlessly.

### Usage

1. **Localized Text for UILabel**:

   ```swift
   let localizedLabel: UILabel = // Your UILabel from the Nib file
   localizedLabel.nz.textLocalization = "localized_key"
   ```
   
2. **Localized Text in Nib File**:

   In your nib file, you can set the localized text directly from the Attributes inspector in Xcode. Set the nz_textLocalization property to the localization key. The text of the UILabel will be automatically set to the localized string corresponding to the specified key.

   ![Screenshot 2024-02-16 at 16 27 10](https://github.com/nerdzlab/NerdzUtils/assets/37474736/00087041-0bfa-4dac-94d2-6881c7bcd299)

<br>

---

<br>

# `UIKIt` extensions

<br>

## UINavigationBar+Translucent

The `UINavigationBar+Translucent` extension provides a convenient way to control the translucency of a UINavigationBar.

### Features

- **Translucent State**: Easily set or unset the translucency of a UINavigationBar.

### Usage

```swift
let navigationBar: UINavigationBar = // Your UINavigationBar instance
navigationBar.nz.makeTranslucent(true)
navigationBar.nz.makeTranslucent(false)
```
<br>

---

## UINavigationController+Completion

The `UINavigationController+Completion` extension in the NerdzUtils framework enhances the UINavigationController by providing completion closures for various navigation operations.

### Features

- **Push View Controller with Completion**: Execute a closure after pushing a view controller onto the navigation stack.
- **Pop to View Controller with Completion**: Execute a closure after popping to a specific view controller.
- **Pop View Controller with Completion**: Execute a closure after popping the top view controller.
- **Pop to Root View Controller with Completion**: Execute a closure after popping to the root view controller.

### Usage

1. **Push View Controller with Completion**:

   ```swift
   let navigationController: UINavigationController = // Your UINavigationController instance
   let viewController: UIViewController = // The view controller to push

   navigationController.nz.pushViewController(viewController, animated: true) {
       print("ViewController pushed!")
   }
   ```
   
2. **Pop to View Controller with Completion**:

   ```swift
   let navigationController: UINavigationController = // Your UINavigationController instance
   let viewController: UIViewController = // The view controller to pop to

   navigationController.nz.popToViewController(viewController, animated: true) {
       print("Popped to ViewController!")
   }
   ```
   
3. **Pop View Controller with Completion**:

    ```swift
    let navigationController: UINavigationController = // Your UINavigationController instance

    navigationController.nz.popViewController(animated: true) {
        print("Popped top ViewController!")
    }
    ```

4. **Pop to Root View Controller with Completion**:

    ```swift
    let navigationController: UINavigationController = // Your UINavigationController instance
    
    navigationController.nz.popToRootViewController(animated: true) {
        print("Popped to Root ViewController!")
    }
    ```
<br>

---

## UITextField+Localized

The `UITextField+Localized` extension enhances the UITextField by providing functionality to set localized text and placeholder directly from Interface Builder or programmatically.

### Features

- **Localized Text**: Set the localized text of a UITextField from nib files.
- **Localized Placeholder**: Set the localized placeholder of a UITextField from nib files.

### Usage

1. **Localized Text**:

   Set the localized text directly from Interface Builder or programmatically.

   - **From Interface Builder**:

     Set the `nz_textLocalization` property in the Attributes inspector of the UITextField.

     <img width="268" alt="Screenshot 2024-02-18 at 15 27 24" src="https://github.com/nerdzlab/NerdzUtils/assets/37474736/254a8ad2-35d2-4054-8620-93c67018320e">

   - **Programmatically**:

     ```swift
     let textField: UITextField = // Your UITextField instance
     textField.nz_textLocalization = "localized_key"
     ```

2. **Localized Placeholder**:

   Set the localized placeholder directly from Interface Builder or programmatically.

   - **From Interface Builder**:

     Set the `nz_placeholderLocalization` property in the Attributes inspector of the UITextField.

     <img width="268" alt="Screenshot 2024-02-18 at 15 27 24" src="https://github.com/nerdzlab/NerdzUtils/assets/37474736/254a8ad2-35d2-4054-8620-93c67018320e">

   - **Programmatically**:

     ```swift
     let textField: UITextField = // Your UITextField instance
     textField.nz_placeholderLocalization = "localized_placeholder_key"
     ```
<br>

---

## UITextField+PasswordVisibility

The `UITextField+PasswordVisibility` extension enhances the UITextField by providing a password visibility toggle.

### Features

- **Password Visibility Toggle**: Enable or disable a visibility toggle for the password field.

### Properties

| Name | Type | Accessibility | Description |
| ---- | ---- | -------------- | ----------- |
| `nz_isPasswordVisibilityToggleEnabled` | `Bool` | `read-write` `IBInspectable` | Enable or disable the password visibility toggle directly from Interface Builder or programmatically. |

## Usage

### Enable Password Visibility Toggle

#### From Interface Builder:

Set the `nz_isPasswordVisibilityToggleEnabled` property in the Attributes inspector of the UITextField.

<img width="267" alt="Screenshot 2024-02-18 at 15 35 57" src="https://github.com/nerdzlab/NerdzUtils/assets/37474736/100d3c84-e5da-4e72-bbe8-9284a487c3f6">

#### Programmatically:

```swift
let passwordTextField: UITextField = // Your UITextField instance
passwordTextField.nz_isPasswordVisibilityToggleEnabled = true
```
<br>

---

## UIView+AddDashedBorder

The `UIView+AddDashedBorder` extends the UIView class by providing a convenient method to add a dashed border to a view.

### Features

- **Dashed Border Addition**: Add a dashed border with customizable properties such as stroke color, fill color, position, line width, line join, line dash pattern, and corner radius.

### Methods

`func addDashedBorder(...) -> CAShapeLayer`

| Name               | Type                | Default Value        | Description                                                         |
| ------------------ | ------------------- | -------------------- | ------------------------------------------------------------------- |
| `strokeColor`      | `UIColor`           | -                    | The color of the dashed border.                                     |
| `fillColor`        | `UIColor`           | `UIColor.clear`      | The color inside the dashed border.                                  |
| `position`         | `CGPoint`           | `.zero`              | The position of the dashed border.                                   |
| `lineWidth`        | `CGFloat`           | `2`                  | The width of the dashed border lines.                                |
| `lineJoin`         | `CAShapeLayerLineJoin` | `.round`           | The line join style of the dashed border.                            |
| `lineDashPattern`  | `[NSNumber]`        | `[6, 3]`             | The dash pattern of the dashed border.                               |
| `cornerRadius`     | `CGFloat`           | `20`                 | The corner radius of the dashed border.                              |

### Usage

```swift
let myView: UIView = // Your UIView instance
let dashedBorderLayer = myView.nz.addDashedBorder(
    with: .blue,
    fillColor: .clear,
    position: CGPoint(x: 10, y: 10),
    lineWidth: 2,
    lineJoin: .round,
    lineDashPattern: [6, 3],
    cornerRadius: 20
)
```
<br>

---

## UIView+ApplyGradient

The `UIView+ApplyGradient` extension enhances the UIView class by providing a method to easily apply a gradient to a view.

### Features

- **applyGradient(colors:locations:type:startPoint:endPoint:)**: Adds a gradient to the view with customizable properties.

### Parameters

| Name               | Type                | Default Value        | Description                                                         |
| ------------------ | ------------------- | -------------------- | ------------------------------------------------------------------- |
| `colors`           | `[UIColor]`         | -                    | An array of UIColor objects defining the color of each gradient stop.|
| `locations`        | `[NSNumber]`        | -                    | An array of NSNumber objects defining the location of each gradient stop as a value in the range [0,1].|
| `type`             | `CAGradientLayerType` | `.axial`           | The type of gradient.                                               |
| `startPoint`       | `CGPoint`           | `{0.5, 0}`           | The start point of the gradient.                                     |
| `endPoint`         | `CGPoint`           | `{0.5, 1}`           | The end point of the gradient.                                       |

### Usage

```swift
let myView: UIView = // Your UIView instance
let gradientLayer = myView.nz.applyGradient(
    colors: [.red, .blue],
    locations: [0, 1],
    type: .axial,
    startPoint: CGPoint(x: 0.5, y: 0),
    endPoint: CGPoint(x: 0.5, y: 1)
)
```
<br>

---

## UIView+ApplyShadow

The `UIView+ApplyShadow` extension enhances the UIView class by providing a method to easily apply a shadow to a view.

### Features

- **applyShadow(color:opacity:offSet:radius:)**: Easily apply a shadow with customizable properties.

### Parameters

| Name      | Type      | Default Value | Description                            |
| --------- | --------- | ------------- | -------------------------------------- |
| `color`   | `UIColor`  | -             | The color of the shadow.               |
| `opacity` | `Float`    | `0.5`         | The opacity of the shadow.             |
| `offSet`  | `CGSize`   | `.zero`       | The offset of the shadow.              |
| `radius`  | `CGFloat`  | `1`           | The radius of the shadow.              |


### Usage

```swift
let myView: UIView = // Your UIView instance
myView.nz.applyShadow(
    color: .black,
    opacity: 0.7,
    offSet: CGSize(width: 2, height: 2),
    radius: 3
)
```
<br>

---

## UIView+AsImage

The `UIView+AsImage` extension extends the UIView class by providing a method to capture a screenshot of the view.

### Features

- **asImage()**: Captures a screenshot of the view.

### Usage

```swift
let myView: UIView = // Your UIView instance
let screenshotImage = myView.nz.asImage()
```
<br>

---

## UIView+InspectableLayer

The `UIView+InspectableLayer` extension provides inspectable properties for configuring the layer of a UIView.

### Features

- **Inspectable Properties**: Easily configure view properties in Interface Builder without code.

### Properties

| Property          | Type               | Description                                   |
| ----------------- | ------------------ | --------------------------------------------- |
| `cornerRadius`    | `CGFloat`          | View corner radius                            |
| `maskedCorners`   | `CACornerMask`     | View masked corners (available from iOS 11.0) |
| `borderWidth`     | `CGFloat`          | View border width                             |
| `borderColor`     | `UIColor?`         | View border color                             |
| `shadowColor`     | `UIColor?`         | View shadow color                             |
| `shadowAlpha`     | `Float`            | View shadow opacity                           |
| `shadowOffset`    | `CGSize`           | View shadow offset                            |
| `shadowBlur`      | `CGFloat`          | View shadow radius                            |

### Usage

- **From Interface Builder**:

  Set the inspectable properties in the Attributes Inspector of the UIView.

  <img width="267" alt="Screenshot 2024-02-18 at 16 15 13" src="https://github.com/nerdzlab/NerdzUtils/assets/37474736/c9541c42-4630-4202-8dca-913b92e02a48">

- **Programmatically**:

    ```swift
    
    let myView: UIView = // Your UIView instance
    
    // Configure properties programmatically
    myView.cornerRadius = 10.0
    myView.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    myView.borderWidth = 1.0
    myView.borderColor = UIColor.black
    myView.shadowColor = UIColor.gray
    myView.shadowAlpha = 0.5
    myView.shadowOffset = CGSize(width: 2.0, height: 2.0)
    myView.shadowBlur = 5.0
    ```
<br>

---

## UIView+RoundCorners

The `UIView+RoundCorners` extension provides a method to apply rounded corners to specific corners of a UIView and optionally add a border.

### Methods

- **roundCorners(_:radius:borderColor:borderWidth:)**: Applies round corners to the specified corners of the view.

  | Name           | Type          | Default Value | Description                             |
  | -------------- | ------------- | ------------- | --------------------------------------- |
  | `corners`      | `CACornerMask`| -             | The corners to which the radius is applied. |
  | `radius`       | `CGFloat`     | -             | The radius of the rounded corners.      |
  | `borderColor`  | `UIColor`     | `.clear`      | The color of the border.                |
  | `borderWidth`  | `CGFloat`     | `0`           | The width of the border.                |

### Usage

```swift
let myView: UIView = // Your UIView instance

// Apply round corners to the top-left and top-right corners with a radius of 10
// Also, add a border with a color of red and a width of 2
myView.nz.roundCorners(
    [.layerMinXMinYCorner, .layerMaxXMinYCorner],
    radius: 10,
    borderColor: .red, 
    borderWidth: 2
)
```
<br>

---

## UIViewController+AddChild

The `UIViewController+AddChild` extension provides a method to easily add a child view controller with all necessary configurations.

### Method

- **easilyAddChild(_:on:configurationAction:)**: Adds a child view controller to the specified container with optional configuration.

  | Parameter             | Type                         | Default Value           | Description                                                                                   |
  | --------------------- | ---------------------------- | ----------------------- | --------------------------------------------------------------------------------------------- |
  | `childController`     | `UIViewController`           | -                       | The view controller to be added as a child.                                                  |
  | `container`           | `UIView?`                    | `nil`                   | The container view to which the child view controller will be added. If not provided, `view` of the base view controller will be used.              |
  | `configurationAction` | `((UIView, UIView) -> Void)` | `UIViewController.nz.setupFullscreen` | The configuration action to set up constraints. If not provided, it will become full size of the container. |

### Usage

```swift
let parentViewController: UIViewController = // Your parent view controller
let childViewController: UIViewController = // Your child view controller

// Add child view controller to the parent view controller's view with default configuration
parentViewController.nz.easilyAddChild(childViewController)

// Add child view controller to a custom container view with custom configuration
let customContainerView: UIView = // Your custom container view
parentViewController.nz.easilyAddChild(childViewController, on: customContainerView) { childView, parentView in
    // Your custom configuration code for constraints
}
```
<br>

---

## UIViewController+Overlay

The `UIViewController+Overlay` extension provides methods to present and dismiss the current view controller as an overlay.

### Methods

- **presentAsOverlay()**: Presents the current view controller as an overlay.
- **dismissOverlay() throws**: Dismisses the current view controller if it was presented as an overlay.

  Throws:
  - `OverlayPresentationError.noWindow`: If the view does not have a window available.
  - `OverlayPresentationError.notOverlay`: If the view controller was not presented as an overlay.

### Usage

```swift
let viewController: UIViewController = // Your view controller

// Present the view controller as an overlay
viewController.nz.presentAsOverlay()

// Dismiss the overlay if it was presented
do {
    try viewController.nz.dismissOverlay()
}
catch {
    print(error.localizedDescription)
}
```
<br>

---

## UIViewController+Top

The `UIViewController+Top` extension provides a property to get the top presented or pushed view controller.

### Properties

- **topController**: The top presented or pushed view controller.

### Usage

```swift
let viewController: UIViewController = // Your view controller
let topController = viewController.nz.topController
```
<br>

---

<br>

# **[UI Components]()**

<br>

## LoadableButton

The `LoadableButton` is a class that extends `UIButton` to provide loading functionality with an activity indicator.

### Properties

| Name                          | Type                     | Default Value | Description                                                                                       |
| ----------------------------- | ------------------------ | ------------- | ------------------------------------------------------------------------------------------------- |
| `onStartLoading`              | `LoadableButtonEmptyAction` | -           | A closure to be executed when the loading starts.                                                |
| `onFinishLoading`             | `LoadableButtonEmptyAction` | -           | A closure to be executed when the loading finishes.                                              |
| `topBottomIndicatorPadding`   | `CGFloat`                | `10`          | The spacing for the activity indicator from the top and bottom of the button.                    |
| `isLoading`                   | `Bool`                   | `false`       | A boolean value indicating whether the button is in the loading state.                             |
| `activityIndicatorView`       | `UIView`                 | -             | The view representing the loading indicator.                                                      |

### Usage

1. **Set the Loading State**:

    ```swift
    let loadableButton: LoadableButton = // Your LoadableButton instance
    
    // Set the loading state
    loadableButton.isLoading = true
    ```

2. **Customize the Loading Button**:

    ```swift
    let loadableButton: LoadableButton = // Your LoadableButton instance
    
    // Customize the loading button
    loadableButton.topBottomIndicatorPadding = 15
    loadableButton.activityIndicatorView = customActivityIndicatorView
    ```

3. **Handle Loading Events**:

    ```swift
    let loadableButton: LoadableButton = // Your LoadableButton instance
    
    loadableButton.onStartLoading = {
        // Code to execute when loading starts
    }
    
    loadableButton.onFinishLoading = {
        // Code to execute when loading finishes
    }
    ```
<br>

---

## LoadableImageView (`ImageStoringPolicy` enum)

Represents a way of storing loaded image by `LoadableImageView` class

> For more information follow the documentation of `LoadableImageView`

<br>

### Cases

```swift
.none
```

*No storing needed*

<br>

```swift
.cache(timeout: TimeInterval? = nil)
```

*Loaded image needs to be cached*

> If the timeout is not provided - an image will be cached while the target exists.

Name | Type | Default value | Description
------------ | ------------ | ------------- | -------------
`timeout` | `TimeInterval?` | `nil` | A duration after what cached image needs to be reloaded

<br>

---

## SpinnerLoader

#### Methods

- `startSpinnerLoading(with color: UIColor? = nil, size: CGFloat? = nil)`

    | Parameter | Type       | Default Value | Description                                           |
    | ----------| ---------- | ------------- | ----------------------------------------------------- |
    | `color`   | `UIColor?` | `nil`         | The color of the loader spinner.                      |
    | `size`    | `CGFloat?` | `nil`         | The size of the loader spinner.                       |
    
    Starts loading with a spinner.

- `stopSpinnerLoading()`

    Stops loading.

### Usage

1. **Start Loading with Spinner**:

    ```swift
    yourView.startSpinnerLoading(with: .white, size: 15.0)
    ```

2. **Stop Loading**:

    ```swift
    yourView.stopSpinnerLoading()
    ```

<br>

---

<br>

# **Utils**

<br>

---

## ***Property Wrappers***:

<br>

## `@DefaultsProperty`

A property wrapper that simplifies syncing a property with `UserDefaults`, providing automatic initialization and retrieval of values.

### Initializer

- **`init(_ key:, initial:, defaults:)`**:

    | Parameter     | Type              | Default Value | Description                                           |
    | ------------- | ----------------- | ------------- | ----------------------------------------------------- |
    | `key`         | `String`          |       -       | The key for storing the value in UserDefaults.         |
    | `initial`     | `Type`            |       -       | The initial value for cases when UserDefaults is empty.|
    | `defaults`    | `UserDefaults`    |       `.standard`       | UserDefaults instance.|

### Properties

- `wrappedValue`: Gets or sets the value of the property wrapper.

### Usage

1. **Basic Usage**:

    ```swift
    @DefaultsProperty("userLoggedIn", initial: false)
    var isUserLoggedIn: Bool
    ```
    
2. **Custom UserDefaults**:

    ```swift
    let customUserDefaults = UserDefaults(suiteName: "com.example.app")
    
    @DefaultsProperty("darkModeEnabled", initial: false, defaults: customUserDefaults)
    var isDarkModeEnabled: Bool
    ```
<br>

---

## `@KeychainProperty`

A property wrapper facilitating the automatic synchronization of a property with the `Keychain`, offering seamless initialization and retrieval of values.

### Initializer

- **`init(_ key:, initial:, keychain:))`**

    | Parameter     | Type              | Default Value | Description                                                             |
    | ------------- | ----------------- | ------------- | ----------------------------------------------------------------------- |
    | `key`         | `String`          |       -       | The key for storing the value in Keychain.                              |
    | `initial`     | `Type`            |       -       | The initial value for cases when Keychain is empty.                     |
    | `keychain`    | `Keychain`        |       `Keychain(service: Bundle.main.bundleIdentifier ?? "")`       | Keychain instance.|

### Properties

- `wrappedValue`: Gets or sets the value of the property wrapper.

### Usage

1. **Basic Usage**:

    ```swift
    @KeychainProperty("userAuthToken", initial: "")
    var userAuthToken: String
    ```
    
2. **Custom UserDefaults**:

    ```swift
    let customKeychain = Keychain(service: "com.example.app.keychain")
    
    @KeychainProperty("userPassword", initial: "", keychain: customKeychain)
    var userPassword: String
    ```
<br>

---

## AtomicAsyncOperation

The `AtomicAsyncOperation` class encapsulates the logic of executing a single operation at a time, ensuring that the operation is not initiated concurrently by multiple requests. If an operation is already in progress, additional requests will be added to a completions list, and their closures will be invoked after the initial operation finishes. This approach minimizes redundant executions and provides a solution for scenarios such as lazy initialization of services or optimizing request execution.

> ***NOTE***: *This class uses a background queue internally, so ensure that all UI actions are wrapped in the main queue.*

### Initialization

- **`init(action:)`**

    | Parameter | Type                | Default Value | Description                                           |
    | --------- | ------------------- | ------------- | ----------------------------------------------------- |
    | `action`  | `Action` completion | -             | The execution action that needs to be performed.      |

### Properties

- **`action`**: The execution action closure.
- **`isRunning`**: A boolean indicating whether the operation is currently in progress.

### Methods

- **`perform(completion:)`**: Perform the operation if it is not running yet, or add it to the completions list if it is already running.

    | Parameter    | Type          | Default Value | Description                                                |
    | ------------ | ------------- | ------------- | ---------------------------------------------------------- |
    | `completion` | `Completion?` | nil           | A completion closure to be called when execution finishes. |

### Usage

```swift
let asyncOperation = AtomicAsyncOperation { completion in
    // Perform your asynchronous operation logic here
    // For example, fetching data from a network API
    fetchDataFromAPI { result in
        // Process the result
        // ...

        // Notify completion when finished
        completion()
    }
}

// Trigger the asynchronous operation
asyncOperation.perform {
    // Closure to be executed when the operation completes
    // This can be used to update the UI or perform additional tasks
}
```
<br>

---

## `DelayedAction`

The `DelayedAction` class provides a mechanism to delay the execution of a closure and allows for cancellation or rescheduling if needed.

### Methods

- **`cancel() -> Bool`**:

    Cancels any pending execution of the action.

    | Return Type | Description                                                           |
    | ----------- | --------------------------------------------------------------------- |
    | `Bool`      | Returns `true` if the cancellation was successful, `false` otherwise. |

- **`perform(after:, queue:, action:)`**:

    Schedules the execution of the action after a specified delay.

    | Parameter | Type             | Default Value | Description                                            |
    | --------- | ---------------- | ------------- | ------------------------------------------------------ |
    | `delay`   | `TimeInterval`   | -             | The delay after which the action needs to be executed. |
    | `queue`   | `DispatchQueue`  | `.main`       | The queue on which the action will be executed.        |
    | `action`  | `() -> Void`     | -             | The action that needs to be executed.                  |

### Usage

1. **Delayed Execution**:

    ```swift
    let delayedAction = DelayedAction()

    // Schedule an action to be executed after a delay
    delayedAction.perform(after: 2.0) {
        print("Delayed action executed!")
    }

    // Cancelling the pending execution (if needed)
    delayedAction.cancel()
    ```

2. **Rescheduling an Action**:

    ```swift
    let delayedAction = DelayedAction()

    delayedAction.perform(after: 3.0) {
        print("Initial action executed!")
    }

    // Rescheduling the action to be executed sooner
    delayedAction.perform(after: 1.0) {
        print("Rescheduled action executed!")
    }
    ```
<br>

---

## IdType

The `IdType` protocol defines the requirements for types representing unique identifiers. It is commonly used when you have various types of entities (e.g., users, products, etc.) that need a standardized way to represent their identity. It ensures uniqueness and facilitates operations like equality comparisons `(==)` and hashing.

### Protocol Overview

- **`IdType: Hashable`**:

    The protocol requires conformance to the `Hashable` protocol, allowing instances to be used in hash-based collections.

- **`var id: ID { get }`**:

    A property `id` of type `ID` representing the unique identifier for an instance. An associated type `ID` representing the identifier, also conforming to `Hashable`. This allows flexibility in the type of identifier, such as `String` or `Int`.

### Subprotocols

- **`StringIdType: IdType`**:

    A subprotocol of `IdType` where the associated identifier type is `String`.

- **`IntIdType: IdType`**:

    A subprotocol of `IdType` where the associated identifier type is `Int`.

### Default Implementation

- **`hash(into hasher:, inout Hasher)`**:

    An extension method that provides a default implementation for hashing, combining the hash value of the identifier.

    | Parameter        | Type           | Description                                       |
    | ---------------- | -------------- | ------------------------------------------------- |
    | `hasher`         | `inout Hasher` | The hasher to use when combining the hash values. |

### Operator Overload

- **`==` Operator Overload**:

    An overload of the equality operator (`==`) for instances conforming to `IdType`, comparing their identifiers for equality.

#### Usage

```swift
// Example conforming type
struct UserID: IntIdType {
    let id: Int
}

// Example usage
let user1 = UserID(id: 42)
let user2 = UserID(id: 42)

// Equality comparison
let areEqual = (user1 == user2) // true

// Hashing
var hasher = Hasher()
user1.hash(into: &hasher)
let hashValue1 = hasher.finalize()

print("Hash Value for User 1: \(hashValue1)")
```

<br>

---

## `SyncPropertyActor`

The `SyncPropertyActor` is an actor-based container designed to provide thread-safe access to a property of a given type.

### Initialization
- **`init(_ value: T)`**: Initializes a new instance of SyncPropertyActor with the specified initial value.

  | Parameter | Type | Description                                     |
  | --------- | ---- | ----------------------------------------------- |
  | `value`   | `T`  | The initial value to be stored in the property. |

### Methods

- **`setNewValue(_ value: T)`**: Sets a new value for the property, ensuring thread safety

  | Parameter | Type | Description              |
  | --------- | ---- | ------------------------ |
  | `value`   | `T`  | The new value to be set. |

- **`modify(with closure: (inout T) -> Void)`**: Modifies the property's value using a closure, ensuring thread safety.

  | Parameter | Type                | Description                                    |
  | --------- | ------------------- | ---------------------------------------------- |
  | `closure` | `(inout T) -> Void` | A closure that takes an `inout` parameter representing the property's value. Use this closure to modify the value safely. |

### Usage

1. **Setting a new value**:

    ```swift
    private let nextProductsPageLink = SyncPropertyActor<URL?>(nil)
    
    Task {
        // Use the setNewValue method to set the property to a new URL.
        await nextProductsPageLink.setNewValue(URL(string: "https://example.com/nextpage"))
    }
    ```

1. **Modifying existing value**:

    ```swift
    // Example of modifying the property within a task
    Task {
        nextProductsPageLink.modify { currentURL in
            // Modify the current URL, for example, appending a query parameter
            currentURL?.appendPathComponent("additionalPath")
        }
    }
    ```
<br>

---

## @ `Weak<T>` class

**TYPE**: `class`

Adding a possibility of having a weak reference in strong wrapper. Useful for cases when you need a weak reference for objects in `Array` or `Dictionary`

<br>

### Usage examples

```swift
class SomeClass {
    // All objects stored in this array will be stored with weak reference
    private let weekArray = Array<Weak<AnotherClass>>()
}
```

<br>

### Properties

Name | Type | Accessibility | Description
------------ | ------------ | ------------- | -------------
`object` | `T?` | `read-write` | Wrapped object

<br>

### Methods

```swift
init(_ object: T?)
```

*Initialize wrapper with wrapped object*

Name | Type | Default value | Description
------------ | ------------ | ------------- | -------------
`object` | `T?` | | Wrapped object

<br>
<br>
<br>
<br>
