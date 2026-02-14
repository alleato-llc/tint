// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Tint",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "Tint", targets: ["Tint"]),
    ],
    targets: [
        .target(name: "Tint", path: "Sources/Tint"),
        .testTarget(name: "TintTests", dependencies: ["Tint"]),
    ]
)
