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
            path: "Sources/AetherCircleCore"
        ),
        .target(
            name: "QuestApplication",
            dependencies: ["AetherCircleCore"],
            path: "Sources/QuestApplication"
        ),
    ],
    swiftLanguageModes: [.v6]
)

