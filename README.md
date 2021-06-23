# NerdzUtils

`NerdzUtils` is a list of useful classes and extensions for simplifying development with `Swift` language and `UIKit` framework

<br>
<br>
<br>

# @ `LoadableImageView` class

**TYPE**: `class`

**INHERITS**: `UIImageView`

### Subtypes

- `LoadableImage`
- `ImageStoringPolicy`

An image view that automatically handle loading image from `URL`, supports placeholders, `blur.sh`, and caching of preloaded image

> Using of native `image` property of `UIImageView` class will lead to incorrect behaviour

> You should always use `loadableImage` property for setting an image

<br>

### Usage examples

```
avatarImageView.loadableImage = .fromUrl(object.url)
```

```
avatarImageView.loadableImage = .named("emoji-avatar")
```

```
let blurInfo = BlurHashInfo(
    hash: object.hash, 
    size: CGSize(width: 16, height: 16
)

avatarImageView.loadableImage = .fromUrl(
    object.url, 
    storingPolicy: .cache(timeout: 3600), 
    blurHash: blurInfo)

```

<br>

### Properties

Name | Type | Accessibility | Description
------------ | ------------- | ------------- | -------------
`placeholderImage` | `UIImage?` | `read-write` `IBInspectable` | An image that will be used as a placeholder during loading process
`loadableImage` | `LoadableImage` | `read-write` | A representation of an image that needs to be loaded

<br>

## @ `LoadableImageView.LoadableImage` enum

**TYPE**: `enum`

An enum that represents different ways of loading image for `LoadableImageView`

<br>

### Cases

```
.fromUrl(
    _ url: URL?,
    storingPolicy: ImageStoringPolicy,
    blurHash: BlurHashInfo? = nil,
    completion: ((UIImage?) -> Void)? = nil
)
```

*Representation of an image in `URL` format*

Name | Type | Default value | Description
------------ | ------------ | ------------- | -------------
`url` | `URL?` | | A url from witch image should be loaded
`storingPolicy` | `ImageStoringPolicy` | | A storing policy for loaded image
`blurHash` | `BlurHashInfo?` | `nil` | An informatiom for image `blur.sh` if it is supported by image
`completion` | `((UIImage?) -> Void)?` | `nil` | Completion closure that will be called after image is loaded

<br>

---

```
.fromData(
    _ data: Data?, 
    scale: CGFloat = 1
)
```

*Representation of an image in `Data` format*

Name | Type | Default value | Description
------------ | ------------ | ------------- | -------------
`data` | `Data?` | | A data from witch image needs to be loaded
`scale` | `CGFloat` | `1` | A scale factor for data image

<br>

---

```
.named(_ name: String)
```

*Representation  of a local image that can be retrived by name*

Name | Type | Default value | Description
------------ | ------------ | ------------- | -------------
`name` | `String` | | Image local name

<br>

---

```
.image(_ image: UIImage)
```

*`UIImage` representation*

Name | Type | Default value | Description
------------ | ------------ | ------------- | -------------
`image` | `UIImage` | | Image that needs to be set

<br>

---

```
.placeholder
```

*Setting image to placeholder state*

<br>

## @ `LoadableImageView.ImageStoringPolicy` enum

**TYPE**: `enum`

Represents a way of storing loaded image by `LoadableImageView` class

> For more imformation follow the docummentation of `LoadableImageView`

<br>

### Cases

```
.none
```

*No storing needed*

<br>

---

```
.cache(timeout: TimeInterval? = nil)
```

*Loaded image needs to be cached*

> If timeout is not provided - image will be cached while target exist

Name | Type | Default value | Description
------------ | ------------ | ------------- | -------------
`timeout` | `TimeInterval?` | `nil` | A duration after what cached image needs to be reloaded

<br>
<br>
<br>
<br>

## @ `Weak<T>` class

**TYPE**: `class`

Adding a possibility of having a weak referance in strong wrapper. Useful for cases when you need a weak referance for objects in `Array` or `Dictionary`

<br>

### Usage examples

```
class SomeClass {
    // All objects stored in this array will be storred with weak reference
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

```
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
