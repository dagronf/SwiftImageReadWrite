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

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// A codable wrapper for NSImage/UIImage
@available(macOS 10.13, iOS 13, tvOS 13, watchOS 6, *)
public struct PlatformImageCodable: Codable {
	/// The image to encode
	public var image: PlatformImage

	/// Create with a specific image
	public init(_ image: PlatformImage) {
		self.image = image
	}
}

@available(macOS 10.13, iOS 13, tvOS 13, watchOS 6, *)
public extension PlatformImageCodable {
	/// The types of error that the codable image can throw
	enum ImageCodingError: Error {
		case InvalidData
		case UnableToConvertImageToPNG
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		guard let imageData = try? container.decode(Data.self) else {
			throw ImageCodingError.InvalidData
		}

		guard let image = try NSKeyedUnarchiver.unarchivedObject(ofClass: PlatformImage.self, from: imageData) else {
			throw ImageCodingError.InvalidData
		}

		self.image = image
	}

	func encode(to encoder: Encoder) throws {
		let data = try NSKeyedArchiver.archivedData(withRootObject: self.image, requiringSecureCoding: true)
		var container = encoder.singleValueContainer()
		try container.encode(data)
	}
}
