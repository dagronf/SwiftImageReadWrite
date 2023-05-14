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
import ImageIO

public extension CGImage {
	/// Return the image data in the required format
	/// - Parameters:
	///   - type: The format type to export (with options)
	///   - otherOptions: Other options as defined in [documentation](https://developer.apple.com/documentation/imageio/cgimagedestination/destination_properties)
	/// - Returns: The formatted data, or nil on error
	func imageData(for type: ImageExportType, otherOptions: [String: Any]? = nil) -> Data? {
		switch type {
		case .png(scale: let scale, excludeGPSData: let excludeGPSData):
			return self.dataRepresentation(
				type: type.type,
				dpi: scale * 72.0,
				excludeGPSData: excludeGPSData,
				otherOptions: otherOptions
			)
		case .gif:
			return self.dataRepresentation(
				type: type.type,
				dpi: 72.0,
				otherOptions: otherOptions
			)
		case .jpg(scale: let scale, compression: let compression, excludeGPSData: let excludeGPSData):
			return self.dataRepresentation(
				type: type.type,
				dpi: scale * 72.0,
				compression: compression,
				excludeGPSData: excludeGPSData,
				otherOptions: otherOptions
			)
		case .tiff(scale: let scale, compression: let compression, excludeGPSData: let excludeGPSData):
			return self.dataRepresentation(
				type: type.type,
				dpi: scale * 72.0,
				compression: compression,
				excludeGPSData: excludeGPSData,
				otherOptions: otherOptions
			)
		case .pdf(size: let size):
			return self.pdfRepresentation(size: size)
		}
	}
}

// MARK: - Data representation

internal extension CGImage {
	/// Generate a PDF representation of this image
	/// - Parameter size: The output size in pixels
	/// - Returns: PDF data
	func pdfRepresentation(size: CGSize) -> Data? {
		UsingSinglePagePDFContext(size: size) { context, rect in
			context.draw(self, in: CGRect(origin: .zero, size: size))
		}
	}

	func dataRepresentation(
		type: CFString,
		dpi: CGFloat,
		compression: CGFloat? = nil,
		excludeGPSData: Bool = false,
		otherOptions: [String: Any]? = nil
	) -> Data? {
		var options: [CFString: Any] = [
			kCGImagePropertyPixelWidth: self.width,
			kCGImagePropertyPixelHeight: self.height,
			kCGImagePropertyDPIWidth: dpi,
			kCGImagePropertyDPIHeight: dpi,
		]

		if let compression = compression {
			options[kCGImageDestinationLossyCompressionQuality] = compression
		}

		if excludeGPSData == true {
			options[kCGImageMetadataShouldExcludeGPS] = true
		}

		// Add in the user's customizations
		otherOptions?.forEach { options[$0.0 as CFString] = $0.1 }

		guard
			let mutableData = CFDataCreateMutable(nil, 0),
			let destination = CGImageDestinationCreateWithData(mutableData, type, 1, nil)
		else {
			return nil
		}

		CGImageDestinationAddImage(destination, self, options as CFDictionary)
		CGImageDestinationFinalize(destination)

		return mutableData as Data
	}
}
