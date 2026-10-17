// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "AetherCircleQuestApp",
    products: [
        .library(
            name: "AetherCircleQuestApp",
            type: .dynamic,
            targets: ["QuestApplication"]
        ),
    ],
    targets: [
        .target(
            name: "AetherCircleCore",
            // Showcase supplies its own application; bundled demos are not needed.
            path: "Sources/AetherCircleCore",
            exclude: ["Demos"]
        ),
        .target(
            name: "QuestApplication",
            dependencies: ["AetherCircleCore"],
            path: "Sources/QuestApplication"
        ),
    ],
    swiftLanguageModes: [.v6]
)

