// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FlatSwitch",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "FlatSwitch",
            targets: ["FlatSwitch"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FlatSwitch",
            path: "Sources/FlatSwitch"),
        .testTarget(
            name: "FlatSwitchTests",
            dependencies: ["FlatSwitch"],
            path: "Tests/FlatSwitchTests")
    ]
)
