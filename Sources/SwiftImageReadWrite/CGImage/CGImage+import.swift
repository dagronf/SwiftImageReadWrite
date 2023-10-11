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

#if canImport(CoreGraphics)

import Foundation
import CoreGraphics

public extension CGImage {
	/// Load a CGImage from raw image data
	static func load(data: Data) throws -> CGImage {
		guard let image = PlatformImage(data: data)?.cgImage else {
			throw ImageReadWriteError.unableToDecodeImage
		}
		return image
	}

	/// Load a CGImage from a file
	static func load(fileURL: URL) throws -> CGImage {
		assert(fileURL.isFileURL)
		guard let image = PlatformImage(contentsOfFile: fileURL.path)?.cgImage else {
			throw ImageReadWriteError.unableToDecodeImage
		}
		return image
	}

	/// Creates an image object from the specified named asset.
	/// - Parameter name: The image asset name
	/// - Returns: The image
	static func named(_ name: String) throws -> CGImage {
		guard let image = PlatformImage(named: name)?.cgImage else {
			throw ImageReadWriteError.cannotLoadImageNamed(name)
		}
		return image
	}
}

#endif
