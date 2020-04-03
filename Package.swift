// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Aurora",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12)
    ],
    products: [
        .library(name: "Aurora", targets: ["Aurora"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Aurora",
            dependencies: []
        ),
        .testTarget(
            name: "AuroraTests",
            dependencies: ["Aurora"]
        )
    ]
)
