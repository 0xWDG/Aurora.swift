// swift-tools-version:5.1

import PackageDescription

/// Aurora framework for Swift.
let package = Package(
    /// Aurora Framework
    name: "Aurora",
    
    /// It is created for:
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12)
    ],
    
    /// It is a framework/library
    products: [
        .library(name: "Aurora", targets: ["Aurora"])
    ],
    
    /// Hopefully this will never get bigger than 0
    dependencies: [],
    
    /// The targets are:
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
