//
//  Package.swift
//  SwiftMacros
//
//  Created by Aether on 16/01/2026.
//

// swift-tools-version: 6.0

// NOTE: If Xcode shows "Unable to find module dependency: 'SwiftSyntax'" errors,
// ensure xcode-select points to Xcode.app, not Command Line Tools:
//   sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftMacros",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1),
        .macOS(.v10_15),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "SwiftMacros",
            targets: ["SwiftMacros"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-syntax", from: "600.0.0"
        ),
    ],
    targets: [
        .target(
            name: "SwiftMacros",
            dependencies: ["SwiftMacrosPlugin"]
        ),
        .macro(
            name: "SwiftMacrosPlugin",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "SwiftMacrosTests",
            dependencies: ["SwiftMacros"]
        ),
        .testTarget(
            name: "SwiftMacrosPluginTests",
            dependencies: [
                "SwiftMacrosPlugin",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
