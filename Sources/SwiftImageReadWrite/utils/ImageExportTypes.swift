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

/// Image export type
public enum ImageExportType {
	/// PNG export type
	case png(scale: CGFloat = 1, excludeGPSData: Bool = true)
	/// GIF export type
	case gif
	/// JPEG export type
	case jpg(scale: CGFloat = 1, compression: CGFloat? = nil, excludeGPSData: Bool = true)
	/// TIFF export type
	case tiff(scale: CGFloat = 1, compression: CGFloat? = nil, excludeGPSData: Bool = true)
	/// PDF export type
	case pdf(size: CGSize)
	/// HEIC export type. Not supported on macOS < 10.13 (throws an error)
	case heic(scale: CGFloat = 1, compression: CGFloat? = nil, excludeGPSData: Bool = true)
	/// SVG export
	indirect case svg(size: CGSize? = nil, fillStyle: SVGImageFillStyle = .aspectFit, embeddedImageFormat: ImageExportType = .jpg())

	/// The default file extension for the image type
	public var fileExtension: String {
		switch self {
		case .png(scale: _): return "png"
		case .gif: return "gif"
		case .jpg(scale: _, compression: _, excludeGPSData: _): return "jpg"
		case .tiff(scale: _, compression: _, excludeGPSData: _): return "tiff"
		case .pdf(size: _): return "pdf"
		case .heic(scale: _, compression: _, excludeGPSData: _): return "heic"
		case .svg(size: _, fillStyle: _, embeddedImageFormat: _): return "svg"
		}
	}

	/// The raw UTType for each type
	internal var utType: CFString {
		switch self {
		case .png(scale: _): return kUTTypePNG
		case .gif: return kUTTypeGIF
		case .jpg(scale: _, compression: _, excludeGPSData: _): return kUTTypeJPEG
		case .tiff(scale: _, compression: _, excludeGPSData: _): return kUTTypeTIFF
		case .pdf(size: _): return kUTTypePDF
		case .heic(scale: _, compression: _, excludeGPSData: _): return kUTTypeHEIC
		case .svg(size: _, fillStyle: _, embeddedImageFormat: _): return kUTTypeSVG
		}
	}

	public var mimeType: String {
		switch self {
		case .png(scale: _): return "image/png"
		case .gif: return "image/gif"
		case .jpg(scale: _, compression: _, excludeGPSData: _): return "image/jpeg"
		case .tiff(scale: _, compression: _, excludeGPSData: _): return "image/tiff"
		case .pdf(size: _): return "application/pdf"
		case .heic(scale: _, compression: _, excludeGPSData: _): return "image/heic"
		case .svg(size: _, fillStyle: _, embeddedImageFormat: _): return "image/svg+xml"
		}
	}
}
