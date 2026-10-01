// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let targetSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .defaultIsolation(MainActor.self),
    .strictMemorySafety(),

    // approachable concurrency:
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("InferIsolatedConformances"),
]

let package = Package(
    name: "Reordering",
    platforms: [.iOS(.v27), .macOS(.v27), .visionOS(.v27)],
    products: [
        .library(
            name: "Reordering",
            targets: ["Reordering"]),
    ],
    targets: [
        .target(
            name: "Reordering",
            swiftSettings: targetSettings
        ),
        .testTarget(
            name: "ReorderingTests",
            dependencies: ["Reordering"]
        ),
    ]
)
