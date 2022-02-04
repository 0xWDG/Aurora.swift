// swift-tools-version:5.3

import PackageDescription

/// Aurora framework for Swift.
let package = Package(
    /// Aurora Framework
    name: "Aurora",

    /// Default localization
    defaultLocalization: "en",

    /// It is created for:
    platforms: [
        // MacOS Catelina (2019)
        .macOS(.v10_15),
        // iOS 13 (2019)
        .iOS(.v13),
        // tvOS 13 (2019)
        .tvOS(.v13),
        // WatchOS 6 (2019)
        .watchOS(.v6)
    ],

    /// It is a framework/library
    products: [
        .library(
            name: "Aurora",
            targets: ["Aurora"]
        )
    ],

    /// Hopefully this will never get bigger than 0
    dependencies: [],

    /// The targets are:
    targets: [
        .target(
            name: "Aurora",
            dependencies: [],
            exclude: [
                // If run from .xcodeproj this file is needed.
                "NoSwiftPM.swift"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "AuroraTests",
            dependencies: [
                "Aurora"
            ],
            exclude: [],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
