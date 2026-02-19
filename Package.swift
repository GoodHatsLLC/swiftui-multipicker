// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swiftui-multipicker",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "MultiPicker", targets: ["MultiPicker"]),
    ],
    targets: [
        .target(name: "MultiPicker"),
        .testTarget(name: "MultiPickerTests", dependencies: ["MultiPicker"]),
    ]
)
