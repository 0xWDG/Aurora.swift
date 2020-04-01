// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Aurora",
    products: [
        .library(name: "Aurora", targets: ["Aurora"]),
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
        ),
    ]
)
