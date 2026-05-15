// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "ginette",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/klolev/Slingshot.git", from: "0.4.20"),
        .package(url: "https://github.com/DiscordBM/DiscordBM", from: "1.16.1"),
    ],
    targets: [
        .target(name: "BingoSheetPrintService"),
        .target(name: "BingoSheetBrowserlessPrintService", dependencies: [.target(name: "BingoSheetPrintService")]),
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Slingshot", package: "Slingshot"),
                .product(name: "DiscordBM", package: "DiscordBM"),
                .target(name: "BingoSheetPrintService"),
                .target(name: "BingoSheetBrowserlessPrintService"),
            ],
            resources: [.copy("Images/bingo.gif")],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("StrictConcurrency"),
] }
