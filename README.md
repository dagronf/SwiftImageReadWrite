# SwiftImageReadWrite

A basic Swift microframework of routines for doing basic importing/exporting of `CGImage` and `NSImage`/`UIImage` type images.

<p align="center">
    <img src="https://img.shields.io/github/v/tag/dagronf/SwiftImageReadWrite" />
    <img src="https://img.shields.io/badge/License-MIT-lightgrey" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    <img src="https://img.shields.io/badge/pod-compatible-red" />
    </a>
</p>
<p align="center">
    <img src="https://img.shields.io/badge/macOS-10.11+-red" />
    <img src="https://img.shields.io/badge/iOS-13+-blue" />
    <img src="https://img.shields.io/badge/tvOS-13+-orange" />
    <img src="https://img.shields.io/badge/watchOS-6+-brightgreen" />
    <img src="https://img.shields.io/badge/macCatalyst-1.0+-purple" />
</p>

## Why?

Sometimes all you need is to be able load and save basic image data in different formats. 
This framework provides a basic wrapper around the common use cases.

Apple's built in image types are incredibly capable but can be quite verbose to do basic import and export to 
different image file types. It's also somewhat tricky to get basic export correct, so this framework abstracts that
away with a type-safe, format safe way.

There are also differences between macOS and the rest of the Apple ecosystem when it comes to converting platform
images and this library abstracts those differences away. The same API will work on macOS/iOS/watchOS and tvOS.

It also provides `Codable` wrapper implementations for CGImage/NSImage/UIImage 
(`CGImageCodable`, `PlatformImageCodable`) to allow easy embedding of images in your `Codable` objects. 

## Supported types

* PNG
* JPEG
* TIFF
* GIF
* HEIC
* PDF

## `representation`

All the encoding/conversion calls are wrapped inside `representation` on an image object. This was done to 
avoid clashing with the platform image calls of similar names.

For example :-

```swift
let image = UIImage(/* some image */)
let pngData = try image.representation.png(scale: 2)
```

```swift
let image = CGImage(/* some image */)
let pngData = try image.representation.pdf(size: CGSize(width: 300, height: 300))
```

## Basic examples

### CGImage

```swift
// Load a CGImage from raw data
let image = try CGImage.load(imageData: data)

// Export the image as JPG data
let jpegData = try image.representation.jpeg(scale: 3, compression: 0.65, excludeGPSData: true))

// Export the image as PNG data
let pngData = try image.representation.png(scale: 2)
```

### NSImage/UIImage

```swift
// Load a CGImage from raw data
let cgImage = CGImage.load(imageData: data)

// Convert to an NSImage (or UIImage)
let nsImage = cgImage.platformImage(scale: 2)

// Generate a PDF representation of the pdf
let pdf = try nsImage.representation.pdf()
```

### SwiftUI

```swift
// Load a CGImage from raw data
let cgImage = CGImage.load(imageData: data)

// Create a SwiftUI image with this image
let swiftUIImage = cgImage.imageUI(scale: 2, label: Text("My Image"))
```

## Limitations

* `NSImage` supports multiple image representations within a single image. These routines only deal with a single
representation, so an image with multiple stored representations will only ever deal with the 'best' representation.

# License

```
MIT License

Copyright (c) 2023 Darren Ford

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
