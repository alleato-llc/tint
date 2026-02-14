// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Tint",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "Tint", targets: ["Tint"]),
    ],
    dependencies: [
        .package(url: "https://github.com/alleato-llc/pickle-kit.git", branch: "main"),
    ],
    targets: [
        .target(name: "Tint", path: "Sources/Tint"),
        .testTarget(name: "TintTests", dependencies: ["Tint"]),
        .testTarget(
            name: "TintBDDTests",
            dependencies: [
                "Tint",
                .product(name: "PickleKit", package: "pickle-kit"),
            ]
        ),
    ]
)
