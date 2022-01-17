// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
	name: "SSC",
	platforms: [
		.macOS(.v10_15)
	],
	products: [
		.library(
			name: "SSC",
			targets: [
				"swift-shell-command"
			]
		),
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(
			name: "swift-shell-command",
			dependencies: []),
		.testTarget(
			name: "swift-shell-commandTests",
			dependencies: ["swift-shell-command"]),
	]
)
