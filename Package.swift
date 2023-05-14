// swift-tools-version: 5.4
import PackageDescription

let package = Package(
	name: "SwiftImageReadWrite",
	platforms: [
		.macOS(.v10_11),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v4)
	],
	products: [
		.library(
			name: "SwiftImageReadWrite",
			targets: ["SwiftImageReadWrite"]),
	],
	dependencies: [
	],
	targets: [
		.target(
			name: "SwiftImageReadWrite",
			dependencies: []),
		.testTarget(
			name: "SwiftImageReadWriteTests",
			dependencies: ["SwiftImageReadWrite"],
			resources: [
				.process("resources"),
			]
		)
	]
)
