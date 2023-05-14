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

#if !os(watchOS)

import Foundation
import CoreGraphics
import CoreImage

public extension CIImage {
	/// Convert this image to a CGImage
	@inlinable func cgImage(context: CIContext? = nil) -> CGImage? {
		let ctx = context ?? CIContext(options: nil)
		return ctx.createCGImage(self, from: self.extent)
	}
}

#if os(macOS)
import AppKit
public extension CIImage {
	/// Create an NSImage version of this image
	/// - Parameters:
	///   - pixelSize: The number of pixels in the result image. For a retina image (for example), pixelSize is double repSize
	///   - repSize: The number of points in the result image
	/// - Returns: Converted image, or nil
	@available(macOS 10, *)
	func asNSImage(pixelsSize: CGSize? = nil, repSize: CGSize? = nil) -> NSImage? {
		let rep = NSCIImageRep(ciImage: self)
		if let ps = pixelsSize {
			rep.pixelsWide = Int(ps.width)
			rep.pixelsHigh = Int(ps.height)
		}
		if let rs = repSize {
			rep.size = rs
		}
		let updateImage = NSImage(size: rep.size)
		updateImage.addRepresentation(rep)
		return updateImage
	}
}
#endif

#endif
