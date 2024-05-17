// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "ginette",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.99.3"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        .package(url: "https://github.com/flix477/slingshot.git", from: "0.4.3"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0"),
        .package(url: "https://github.com/DiscordBM/DiscordBM", from: "1.11.0")
    ],
    targets: [
        .target(name: "BingoSheetPrintService"),
        .target(name: "BingoSheetSwiftUIPrintService", dependencies: [.target(name: "BingoSheetPrintService")]),
        .target(name: "DiscordKit"),
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Slingshot", package: "slingshot"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .target(name: "DiscordKit"),
                .target(name: "BingoSheetPrintService"),
                .target(name: "BingoSheetSwiftUIPrintService"),
                .product(name: "DiscordBM", package: "DiscordBM")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                .product(name: "XCTVapor", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("StrictConcurrency"),
] }
