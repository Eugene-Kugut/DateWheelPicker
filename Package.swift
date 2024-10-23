// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DateWheelPicker",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "DateWheelPicker",
            targets: ["DateWheelPicker"]),
    ],
    dependencies: [
        .package(url: "git@github.com:Eugene-Kugut/CustomWheelPicker.git", branch: "main")],
    targets: [
        .target(
            name: "DateWheelPicker",
            dependencies: ["CustomWheelPicker"],
            swiftSettings: [.swiftLanguageMode(.v5)]),

    ]
)
