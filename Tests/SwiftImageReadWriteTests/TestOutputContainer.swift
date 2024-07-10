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


import Foundation

/// A simple wrapper around a temporary folder
class TestOutputContainer {
	// Note:  DateFormatter is thread safe
	// See https://developer.apple.com/documentation/foundation/dateformatter#1680059
	static let iso8601Formatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX ISO8601
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HHmmssZ"
		return dateFormatter
	}()

	private lazy var __tmpFolder: URL = {
		let u = FileManager.default
			.temporaryDirectory
			.appendingPathComponent(name)
			.appendingPathComponent(Self.iso8601Formatter.string(from: Date()))
		try! FileManager.default.createDirectory(at: u, withIntermediateDirectories: true)
		Swift.print("Temp files at: \(u)")
		return u
	}()

	func writeFile(titled: String, data: Data) throws {
		try data.write(to: __tmpFolder.appendingPathComponent(titled))
	}

	private let name: String

	init(name: String) {
		self.name = name
	}
}
