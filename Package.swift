// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Timely",
    products: [
        .library(
            name: "Timely",
            targets: ["Timely"]),
    ],
    targets: [
        .target(
            name: "Timely",
            dependencies: []),
        .testTarget(
            name: "TimelyTests",
            dependencies: ["Timely"]),
    ]
)
