// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Library",
    defaultLocalization: "en",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Pipeline", targets: ["Pipeline"]),
        .library(name: "DIContainer", targets: ["DIContainer"]),
        .library(name: "Service", targets: ["Service"]),
        .library(name: "Localization", targets: ["Localization"])
    ],
    targets: [
        .target(name: "Localization", path: "Sources/Localization", resources: [.process("Resources")]),
        .target(name: "Models", dependencies: ["Localization"], path: "Sources/Models"),
        .target(name: "Pipeline", dependencies: ["Models"], path: "Sources/Pipeline"),
        .target(name: "Networking", dependencies: ["Models", "Pipeline", "DIContainer"], path: "Sources/Networking"),
        .target(name: "DIContainer", path: "Sources/DIContainer"),
        .target(name: "Service", path: "Sources/Service"),
        .testTarget(name: "NetworkingTests", dependencies: ["Networking", "Models"]),
        .testTarget(name: "PipelineTests", dependencies: ["Pipeline"]),
        .testTarget(name: "ModelsTests", dependencies: ["Models"]),
        .testTarget(name: "DIContainerTests", dependencies: ["DIContainer"]),
        .testTarget(name: "ServiceTests", dependencies: ["Service"]),
        .testTarget(name: "LocalizationTests", dependencies: ["Localization"])
    ]
)
