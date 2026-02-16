// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSExtensionKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "iOSExtensionKit",
            targets: ["iOSExtensionKit"]
        ),
        .library(
            name: "iOSExtensionKit-Foundation",
            targets: ["iOSExtensionKit-Foundation"]
        ),
        .library(
            name: "iOSExtensionKit-UIKit",
            targets: ["iOSExtensionKit-UIKit"]
        ),
        .library(
            name: "iOSExtensionKit-SwiftUI",
            targets: ["iOSExtensionKit-SwiftUI"]
        ),
        .library(
            name: "iOSExtensionKit-CoreGraphics",
            targets: ["iOSExtensionKit-CoreGraphics"]
        ),
        .library(
            name: "iOSExtensionKit-Combine",
            targets: ["iOSExtensionKit-Combine"]
        ),
    ],
    targets: [
        // 完整库
        .target(
            name: "iOSExtensionKit",
            dependencies: [
                "iOSExtensionKit-Foundation",
                "iOSExtensionKit-UIKit", 
                "iOSExtensionKit-SwiftUI",
                "iOSExtensionKit-CoreGraphics"
            ],
            path: "Sources/iOSExtensionKit",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
                .enableExperimentalFeature("RegionBasedIsolation"),
            ]
        ),
        
        // Foundation 扩展模块
        .target(
            name: "iOSExtensionKit-Foundation",
            dependencies: [],
            path: "Sources/Foundation",
            swiftSettings: [
                .define("IOSEXTENSIONKIT_FOUNDATION"),
            ]
        ),
        
        // UIKit 扩展模块  
        .target(
            name: "iOSExtensionKit-UIKit",
            dependencies: [],
            path: "Sources/UIKit",
            swiftSettings: [
                .define("IOSEXTENSIONKIT_UIKIT"),
                .unsafeFlags(["-Xfrontend", "-strict-concurrency=targeted"])
            ]
        ),
        
        // SwiftUI 扩展模块
        .target(
            name: "iOSExtensionKit-SwiftUI",
            dependencies: [],
            path: "Sources/SwiftUI",
            swiftSettings: [
                .define("IOSEXTENSIONKIT_SWIFTUI"),
            ]
        ),
        
        // CoreGraphics 扩展模块
        .target(
            name: "iOSExtensionKit-CoreGraphics",
            dependencies: [],
            path: "Sources/CoreGraphics",
            swiftSettings: [
                .define("IOSEXTENSIONKIT_COREGRAPHICS"),
            ]
        ),
        
        // Combine 扩展模块
        .target(
            name: "iOSExtensionKit-Combine",
            dependencies: [],
            path: "Sources/Combine",
            swiftSettings: [
                .define("IOSEXTENSIONKIT_COMBINE"),
            ]
        ),
        
        // 测试目标
        .testTarget(
            name: "iOSExtensionKitTests",
            dependencies: [
                "iOSExtensionKit-Foundation",
                "iOSExtensionKit-UIKit",
                "iOSExtensionKit-SwiftUI",
                "iOSExtensionKit-CoreGraphics",
                "iOSExtensionKit-Combine"
            ],
            path: "Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

