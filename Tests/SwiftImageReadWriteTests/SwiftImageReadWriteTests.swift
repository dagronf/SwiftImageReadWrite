import XCTest
@testable import SwiftImageReadWrite

let output = TestOutputContainer(name: "SwiftImageReadWrite")

func loadImage(forResource name: String, withExtension extn: String) throws -> CGImage {
	let url = Bundle.module.url(forResource: name, withExtension: extn)!
	return try CGImage.load(fileURL: url)
}

final class SwiftImageReadWriteTests: XCTestCase {
	func testExample1() throws {
		let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
		let data = try Data(contentsOf: url)
		let image = try CGImage.load(data: data)

		let pdfData = try image.representation.pdf(size: CGSize(width: 600, height: 600))
		try output.writeFile(titled: "wombles-e1.pdf", data: pdfData)
	}

	func testExampleHEIC() throws {
		do {
			let url = Bundle.module.url(forResource: "sample-heic-image", withExtension: "heic")!
			let data = try Data(contentsOf: url)

			let image = try CGImage.load(data: data)

			let pdfData = try image.representation.pdf(size: CGSize(width: 600, height: 600))
			try output.writeFile(titled: "sample-heic-image-e1.pdf", data: pdfData)

			#if os(watchOS)
			// WatchOS doesn't seem to be able to generate HEIC
			XCTAssertThrowsError(try image.representation.heic())
			#else
			let heicData = try image.representation.heic()
			try output.writeFile(titled: "sample-heic-image-e2.heic", data: heicData)
			#endif
		}

		do {
			let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
			let data = try Data(contentsOf: url)
			let image = try CGImage.load(data: data)

			#if os(watchOS)
			// WatchOS doesn't seem to be able to generate HEIC
			XCTAssertThrowsError(try image.representation.heic(scale: 2, compression: 0.5))
			#else
			let heicData2 = try image.representation.heic(scale: 2, compression: 0.5)
			try output.writeFile(titled: "wombles2.heic", data: heicData2)
			#endif
		}
	}

	func testPlatformImage() throws {
		let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
		let data = try Data(contentsOf: url)
		let image = try XCTUnwrap(PlatformImage(data: data))

		let pngData = try image.representation.png(scale: 2)
		try output.writeFile(titled: "platform-image-scale-2.png", data: pngData)

		let jpgData = try image.representation.jpeg(compression: 0.65)
		try output.writeFile(titled: "platform-image-compression-0.65.jpg", data: jpgData)

		let pdfData = try image.representation.pdf(size: CGSize(width: 200, height: 200))
		try output.writeFile(titled: "platform-image-200x200.pdf", data: pdfData)
	}

	func testExample2() throws {
		let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
		let data = try Data(contentsOf: url)

		let image = try CGImage.load(data: data)

		let jpg2 = try image.representation.jpeg()
		try output.writeFile(titled: "wombles-e2-single-res.jpg", data: jpg2)

		let jpegData = try image.representation.jpeg(scale: 3, compression: 0.65, excludeGPSData: true)
		try output.writeFile(titled: "wombles-e2.jpg", data: jpegData)
	}

	func testLoad() throws {

		let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
		let data = try Data(contentsOf: url)

		let image = try CGImage.load(data: data)
		XCTAssertEqual(image.width, 512)
		XCTAssertEqual(image.height, 512)
	}

	func testExportScale() throws {
		let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
		let data = try Data(contentsOf: url)
		let image = try CGImage.load(data: data)

		let platformImage2 = try XCTUnwrap(image.platformImage(scale: 2)
			.representation.jpeg(scale: 2, compression: 0.65))
		try output.writeFile(titled: "export-scale-2.jpg", data: platformImage2)

		let platformImage3 = try XCTUnwrap(image.platformImage(dpi: 214.0)
			.representation.jpeg(dpi: 214.0, compression: 0.65))
		try output.writeFile(titled: "export-scale-dpi-214.jpg", data: platformImage3)
	}

	func testExportGIF() throws {
		let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
		let data = try Data(contentsOf: url)
		let image = try CGImage.load(data: data)
		let gif = try image.imageData(for: .gif)

		try output.writeFile(titled: "wombles-export-gif.gif", data: gif)
	}

	func testCodable() throws {

		struct MyStruct: Codable {
			let name: String
			let image: PlatformImageCodable
		}

		let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
		let data = try Data(contentsOf: url)
		let image = try XCTUnwrap(PlatformImage(data: data))

		let s = MyStruct(name: "Fishy", image: PlatformImageCodable(image))
		let d = try JSONEncoder().encode(s)

		let recon = try JSONDecoder().decode(MyStruct.self, from: d)
		XCTAssertEqual(recon.name, "Fishy")
		XCTAssertEqual(recon.image.image.size, image.size)
	}

	func testCGCodable() throws {

		struct MyStruct: Codable {
			let name: String
			let image: CGImageCodable
		}

		let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
		let data = try Data(contentsOf: url)
		let image = try CGImage.load(data: data)

		let s = MyStruct(name: "Fishy", image: CGImageCodable(image))
		let d = try JSONEncoder().encode(s)

		let recon = try JSONDecoder().decode(MyStruct.self, from: d)
		XCTAssertEqual(recon.name, "Fishy")
		XCTAssertEqual(recon.image.image.width, image.width)
		XCTAssertEqual(recon.image.image.height, image.height)
	}

	func testSVG() throws {
		do {
			let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
			let data = try Data(contentsOf: url)
			let image = try CGImage.load(data: data)
			try output.writeFile(titled: "wombles-export-gif-embedded-png.svg", data: try image.representation.svg(embeddedImageFormat: .png()))
		}
		do {
			let url = Bundle.module.url(forResource: "sample-heic-image", withExtension: "heic")!
			let data = try Data(contentsOf: url)
			let image = try CGImage.load(data: data)
			try output.writeFile(titled: "sample-heic-image-embedded-jpg.svg", data: try image.representation.svg(embeddedImageFormat: .jpg()))
		}
		do {
			let url = Bundle.module.url(forResource: "sample-heic-image", withExtension: "heic")!
			let data = try Data(contentsOf: url)
			let image = try CGImage.load(data: data)
			try output.writeFile(titled: "sample-heic-image-embedded-tiff.svg", data: try image.representation.svg(embeddedImageFormat: .tiff()))
		}
		do {
			let url = Bundle.module.url(forResource: "sample-heic-image", withExtension: "heic")!
			let data = try Data(contentsOf: url)
			let image = try CGImage.load(data: data)
			try output.writeFile(titled: "sample-heic-image-embedded-gif.svg", data: try image.representation.svg(embeddedImageFormat: .gif))
		}

		do {
			let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
			let data = try Data(contentsOf: url)
			let image = try CGImage.load(data: data)
			try output.writeFile(
				titled: "wombles-image-scaled-40x40.svg",
				data: try image.representation.svg(size: CGSize(width: 40, height: 40), embeddedImageFormat: .jpg())
			)
		}

		do {
			let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
			let data = try Data(contentsOf: url)
			let image = try CGImage.load(data: data)
			try output.writeFile(
				titled: "wombles-image-scaled-100x50-fill.svg",
				data: try image.representation.svg(size: CGSize(width: 100, height: 50), fillStyle: .aspectFill, embeddedImageFormat: .jpg())
			)
		}

		do {
			let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
			let data = try Data(contentsOf: url)
			let image = try CGImage.load(data: data)
			try output.writeFile(
				titled: "wombles-image-scaled-100x50-fit.svg",
				data: try image.representation.svg(size: CGSize(width: 100, height: 50), fillStyle: .aspectFit, embeddedImageFormat: .jpg())
			)
		}

		do {
			let url = Bundle.module.url(forResource: "wombles", withExtension: "jpeg")!
			let data = try Data(contentsOf: url)
			let image = try CGImage.load(data: data)
			try output.writeFile(
				titled: "wombles-image-scaled-100x50-scale.svg",
				data: try image.representation.svg(size: CGSize(width: 100, height: 50), fillStyle: .scale, embeddedImageFormat: .png())
			)
		}

		do {
			let url = Bundle.module.url(forResource: "sample-heic-image", withExtension: "heic")!
			let data = try Data(contentsOf: url)
			let image = try CGImage.load(data: data)
			try output.writeFile(
				titled: "sample-heic-image-scaled-100x50-fill.svg",
				data: try image.representation.svg(size: CGSize(width: 100, height: 50), fillStyle: .aspectFill, embeddedImageFormat: .jpg())
			)

			let ima = image.representation.image(scale: 2)
			Swift.print(ima)
		}

		do {
			let url = Bundle.module.url(forResource: "sample-heic-image", withExtension: "heic")!
			let data = try Data(contentsOf: url)
			let image = try CGImage.load(data: data)
			try output.writeFile(
				titled: "sample-heic-image-scaled-100x50-fit.svg",
				data: try image.representation.svg(size: CGSize(width: 100, height: 50), fillStyle: .aspectFit, embeddedImageFormat: .jpg())
			)
		}

		do {
			let url = Bundle.module.url(forResource: "sample-heic-image", withExtension: "heic")!
			let data = try Data(contentsOf: url)
			let image = try CGImage.load(data: data)
			try output.writeFile(
				titled: "sample-heic-image-scaled-100x50-scale.svg",
				data: try image.representation.svg(size: CGSize(width: 100, height: 50), fillStyle: .scale, embeddedImageFormat: .jpg())
			)
		}
	}

	func testBasicColorspaceConvert() throws {
		do {
			let image = try loadImage(forResource: "wombles", withExtension: "jpeg")
			let cmyk = try image.convertColorspace.genericCMYK().representation.jpeg()
			try output.writeFile(titled: "colorspace-convert-image-converted-to-cmyk.jpg", data: cmyk)
			let gray = try image.convertColorspace.gray().representation.jpeg()
			try output.writeFile(titled: "colorspace-convert-image-converted-to-gray.jpg", data: gray)
			let sRGB = try image.convertColorspace.sRGB().representation.jpeg()
			try output.writeFile(titled: "colorspace-convert-image-converted-to-sRGB.jpg", data: sRGB)
		}

		do {
			let image = try loadImage(forResource: "rainbow", withExtension: "png")
			let cmyk = try image.convertColorspace.genericCMYK().representation.jpeg()
			let rCMYK = try CGImage.load(data: cmyk)
			XCTAssertEqual(CGColorSpace(name: CGColorSpace.genericCMYK), rCMYK.colorSpace)

			try output.writeFile(titled: "colorspace-convert-rainbow-converted-to-cmyk.jpg", data: cmyk)
			let gray = try image.convertColorspace.gray().representation.jpeg()
			try output.writeFile(titled: "colorspace-convert-rainbow-converted-to-gray.jpg", data: gray)
			let rGray = try CGImage.load(data: gray)
			XCTAssertEqual(CGColorSpace(name: CGColorSpace.genericGrayGamma2_2), rGray.colorSpace)
		}

		do {
			let image = try loadImage(forResource: "sample-heic-image", withExtension: "heic")
			let cmyk = try image.convertColorspace.genericCMYK().representation.jpeg()
			try output.writeFile(titled: "colorspace-convert-heic-converted-to-cmyk.jpg", data: cmyk)
			let gray = try image.convertColorspace.gray().representation.jpeg()
			try output.writeFile(titled: "colorspace-convert-heic-converted-to-gray.jpg", data: gray)
		}
	}
}
