//
//  Copyright © 2023 Darren Ford. All rights reserved.
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

import Foundation
import CoreGraphics

/// The style to use when scaling an SVG image
public enum SVGImageFillStyle {
	/// Scale the image to fill the resulting size (which may crop the image)
	case aspectFill
	/// Scale the image to fit the resulting size (which may introduce borders)
	case aspectFit
	/// Scale the image
	case scale
}

public extension CGImage {
	/// Generate an SVG representation for this image
	/// - Parameter embeddingType: The image type to embed
	/// - Returns: The SVG data
	func svgRepresentation(
		size: CGSize? = nil,
		fillStyle: SVGImageFillStyle = .aspectFit,
		embeddedImageFormat: ImageExportType = .jpg()
	) throws -> Data {
		let mimeType = embeddedImageFormat.mimeType
		guard
			mimeType == ImageExportType.jpg().mimeType ||
			mimeType == ImageExportType.png().mimeType ||
			mimeType == ImageExportType.gif.mimeType ||
			mimeType == ImageExportType.tiff().mimeType
		else {
			throw ImageReadWriteError.unsupportedEmbeddedImageType(mimeType)
		}

		let size = size ?? self.size

		var svg = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" version=\"1.1\" "
		svg += " width=\"\(_SVGF(size.width))\" height=\"\(_SVGF(size.height))\" "
		svg += " viewBox=\"0 0 \(_SVGF(size.width)) \(_SVGF(size.height))\" "
		svg += " >\n"

		let rawData = try self.imageData(for: embeddedImageFormat)
		let imageb64d = rawData.base64EncodedData(options: [.lineLength64Characters, .endLineWithLineFeed])
		guard let strImage = String(data: imageb64d, encoding: .ascii) else {
			throw ImageReadWriteError.internalError
		}

		var imagedef = "<image width=\"\(size.width)\" height=\"\(size.height)\" "
		imagedef += " xlink:href=\"data:\(mimeType);base64,"
		imagedef += strImage
		imagedef += "\" x=\"0\" y=\"0\" "
		if fillStyle == .aspectFill {
			imagedef += " preserveAspectRatio=\"xMidYMid slice\" "
		}
		else if fillStyle == .aspectFit {
			imagedef += " " //preserveAspectRatio=\"xMidYMid slice\" "
		}
		else {
			imagedef += "preserveAspectRatio=\"none\" "
		}
		imagedef += " />\n"
		svg += imagedef
		svg += "</svg>"

		guard let data = svg.data(using: .utf8) else {
			throw ImageReadWriteError.internalError
		}
		return data
	}
}

/// Decimal formatter for SVG output
///
/// Note that SVG _expects_ the decimal separator to be '.', which means we have to force the separator
/// so that locales that use ',' as the decimal separator don't produce a garbled SVG
/// See [Issue 19](https://github.com/dagronf/QRCode/issues/19)
private let _svgFloatFormatter: NumberFormatter = {
	let f = NumberFormatter()
	f.decimalSeparator = "."
	f.usesGroupingSeparator = false
	#if os(macOS)
	f.hasThousandSeparators = false
	#endif
	f.maximumFractionDigits = 3
	f.minimumFractionDigits = 0
	return f
}()

private extension CGImage {
	/// Generate a svg-safe float value as a String
	func _SVGF<ValueType: BinaryFloatingPoint>(_ val: ValueType) -> String {
		_svgFloatFormatter.string(from: NSNumber(floatLiteral: Double(val)))!
	}
}
