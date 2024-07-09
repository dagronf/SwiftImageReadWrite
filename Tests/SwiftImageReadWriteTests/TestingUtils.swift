//
//  File.swift
//  
//
//  Created by Darren Ford on 10/7/2024.
//

import Foundation
import XCTest

@testable import SwiftImageReadWrite

/// Returns the fileURL for the specified resource
/// - Parameters:
///   - name: The resource name
///   - extn: The resource extension
/// - Throws: .fileNoSuchFile if the resource file doesn't exist
/// - Returns: URL
func resourceURL(forResource name: String, withExtension extn: String) throws -> URL {
	guard let url = Bundle.module.url(forResource: name, withExtension: extn) else {
		throw CocoaError(.fileNoSuchFile)
	}
	return url
}

/// Load a resource as Data
/// - Parameters:
///   - name: The resource name
///   - extn: The resource extension
/// - Throws: .fileNoSuchFile if the resource file doesn't exist
/// - Returns: Data
func resourceData(forResource name: String, withExtension extn: String) throws -> Data {
	let url = try resourceURL(forResource: name, withExtension: extn)
	return try Data(contentsOf: url)
}

/// Load a resource as a CGImage
/// - Parameters:
///   - name: The resource name
///   - extn: The resource extension
/// - Throws: .fileNoSuchFile if the resource file doesn't exist
/// - Returns: A CGImage
func resourceCGImage(forResource name: String, withExtension extn: String) throws -> CGImage {
	let url = try resourceURL(forResource: name, withExtension: extn)
	return try CGImage.load(fileURL: url)
}

/// Load a resource as a platform image
/// - Parameters:
///   - name: The resource name
///   - extn: The resource extension
/// - Throws: .fileNoSuchFile if the resource file doesn't exist
/// - Returns: A platform image
func resourcePlatformImage(forResource name: String, withExtension extn: String) throws -> PlatformImage {
	let url = try resourceURL(forResource: name, withExtension: extn)
	return try PlatformImage.load(fileURL: url)
}
