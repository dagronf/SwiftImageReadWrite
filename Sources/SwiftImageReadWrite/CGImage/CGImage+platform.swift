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
public extension CGImage {
	/// Return a platform image with a specific scale (eg. 2 == @2x)
	func platformImage(scale: CGFloat = 1) -> PlatformImage {
		let sz = CGSize(width: self.width, height: self.height)
		let scaled = CGSize(width: sz.width / scale, height: sz.height / scale)
		return PlatformImage(cgImage: self, size: scaled)
	}
}
#else
import UIKit

public extension CGImage {
	/// Return a platform image with a specific scale (eg. 2 == @2x)
	func platformImage(scale: CGFloat = 1) -> PlatformImage {
		UIImage(cgImage: self, scale: scale, orientation: .up)
	}
}
#endif

public extension CGImage {
	/// Return a platform image with a specific DPI
	func platformImage(dpi: CGFloat = 72.0) -> PlatformImage {
		self.platformImage(scale: dpi / 72.0)
	}
}
