//
//  Copyright © 2024 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

/// Routines for converting image colorspaces
///
/// ```swift
/// let cmykImage = try image.convertColorspace.genericCMYK()
/// let grayImage = try image.convertColorspace.deviceGray()
/// let sRGBImage = try image.convertColorspace.sRGB()
/// ```

#if canImport(CoreGraphics)

import Foundation
import CoreGraphics

// Default colorspaces
private let csRGB = CGColorSpace(name: CGColorSpace.sRGB)!
private let csCMYK = CGColorSpace(name: CGColorSpace.genericCMYK)!
private let csGray = CGColorSpace(name: CGColorSpace.genericGrayGamma2_2)!

extension CGImage {
	/// Access methods for converting the colorspace
	public var convertColorspace: ConvertColorspace { ConvertColorspace(image: self) }

	/// Colorspace converter container
	public struct ConvertColorspace {
		private var image: CGImage
		fileprivate init(image: CGImage) {
			self.image = image
		}
	}
}

public extension CGImage.ConvertColorspace {
	/// Generate a representation of this image using the Generic CMYK colorspace
	/// - Returns: A new CMYK image
	///
	/// Note: Generic CMYK colorspace does NOT support an alpha channel and will be
	/// stripped on convert
	func genericCMYK() throws -> CGImage {
		let w = Int(image.width)
		let h = Int(image.height)

		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
		guard
			let space = CGColorSpace(name: CGColorSpace.genericCMYK),
			let ctx = CGContext(
				data: nil,
				width: w,
				height: h,
				bitsPerComponent: 8,
				bytesPerRow: w * 4,
				space: space,
				bitmapInfo: bitmapInfo.rawValue
			)
		else {
			throw ImageReadWriteError.cannotConvertColorspace
		}

		ctx.draw(image, in: CGRect(x: 0, y: 0, width: w, height: h), byTiling: false)
		guard let image = ctx.makeImage() else {
			throw ImageReadWriteError.internalError
		}

		return image
	}

	/// Generate a representation of this image using the `genericGrayGamma2_2` colorspace
	/// - Returns: A new image
	///
	/// Note: Gray colorspace does NOT support an alpha channel and will be stripped on convert
	func gray() throws -> CGImage {
		let w = Int(image.width)
		let h = Int(image.height)

		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
		guard
			let ctx = CGContext(
				data: nil,
				width: w,
				height: h,
				bitsPerComponent: 8,
				bytesPerRow: 0,
				space: csGray,
				bitmapInfo: bitmapInfo.rawValue
			)
		else {
			throw ImageReadWriteError.cannotConvertColorspace
		}

		ctx.draw(image, in: CGRect(x: 0, y: 0, width: w, height: h), byTiling: false)
		guard let image = ctx.makeImage() else {
			throw ImageReadWriteError.internalError
		}

		return image
	}

	/// Generate a representation of this image using the standard RGB colorspace
	/// - Returns: A new image
	func sRGB() throws -> CGImage {
		let w = Int(image.width)
		let h = Int(image.height)

		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard
			let ctx = CGContext(
				data: nil,
				width: w,
				height: h,
				bitsPerComponent: 8,
				bytesPerRow: w * 4,
				space: CGColorSpace(name: CGColorSpace.sRGB)!,
				bitmapInfo: bitmapInfo.rawValue
			)
		else {
			throw ImageReadWriteError.cannotConvertColorspace
		}

		ctx.draw(image, in: CGRect(x: 0, y: 0, width: w, height: h), byTiling: false)
		guard let image = ctx.makeImage() else {
			throw ImageReadWriteError.internalError
		}

		return image
	}
}

#endif
