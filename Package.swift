// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "NerdzUtils",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .tvOS(.v12),
        .watchOS(.v4),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "NerdzCore", targets: ["NerdzCore"]),
        .library(name: "NerdzDate", targets: ["NerdzDate"]),
        .library(name: "NerdzUIKit", targets: ["NerdzUIKit"]),
        .library(name: "NerdzKeychain", targets: ["NerdzKeychain"]),
        .library(name: "NerdzUtils", targets: ["NerdzUtils"])
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.0")
    ],
    targets: [
        .target(name: "NerdzCore"),
        .target(name: "NerdzDate", dependencies: ["NerdzCore"]),
        .target(name: "NerdzUIKit", dependencies: ["NerdzCore"]),
        .target(
            name: "NerdzKeychain",
            dependencies: [
                "NerdzCore",
                .product(name: "KeychainAccess", package: "KeychainAccess")
            ]
        ),
        .target(
            name: "NerdzUtils",
            dependencies: ["NerdzCore", "NerdzDate", "NerdzUIKit", "NerdzKeychain"]
        ),
        .testTarget(name: "NerdzCoreTests", dependencies: ["NerdzCore"]),
        .testTarget(name: "NerdzDateTests", dependencies: ["NerdzDate"]),
        .testTarget(name: "NerdzUIKitTests", dependencies: ["NerdzUIKit"]),
        .testTarget(
            name: "NerdzKeychainTests",
            dependencies: [
                "NerdzKeychain",
                .product(name: "KeychainAccess", package: "KeychainAccess")
            ]
        )
    ]
)
