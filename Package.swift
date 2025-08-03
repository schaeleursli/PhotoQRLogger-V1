// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "PhotoQRLogger",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "PhotoQRLogger",
            targets: ["PhotoQRLogger"]
        )
    ],
    targets: [
        .target(
            name: "PhotoQRLogger",
            path: "PhotoQRLogger"
        ),
        .testTarget(
            name: "PhotoQRLoggerTests",
            dependencies: ["PhotoQRLogger"],
            path: "Tests"
        )
    ]
)
