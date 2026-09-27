// swift-tools-version: 6.2

import PackageDescription

// MARK: - Modules

enum Module: String, CaseIterable {
    case account = "Account"
}

// MARK: - Dependencies

enum ModuleDependency {
    enum SharedDependency: String {
        case extensions = "SharedExtensions"
        case designSystem = "UIComponents"
        case navigation = "UIKitNavigation"
    }

    enum LibraryDependency: String {
        case networking = "Networking"
        case models = "Models"
        case pipeline = "Pipeline"
        case diContainer = "DIContainer"
        case service = "Service"
        case localization = "Localization"
    }

    case shared(SharedDependency)
    case library(LibraryDependency)
}

// MARK: - Package

let package = Package(
    name: "Features",
    platforms: [.iOS(.v26)],
    products: Module.allCases.map(\.library),
    dependencies: [
        .package(path: "../Shared"),
        .package(path: "../Library")
    ],
    targets: [
        .target(
            for: .account,
            dependencies: [
                .library(.networking),
                .library(.models),
                .library(.pipeline),
                .library(.diContainer),
                .library(.service),
                .library(.localization),
                .shared(.extensions),
                .shared(.designSystem),
                .shared(.navigation)
            ]
        ),
        .testTarget(
            for: .account,
            dependencies: [
                .library(.networking),
                .library(.models),
                .library(.pipeline),
                .library(.diContainer),
                .library(.service),
                .library(.localization),
                .shared(.extensions),
                .shared(.designSystem)
            ]
        )
    ]
)

// MARK: - Sugar

extension Module {
    var name: String { rawValue }

    var library: PackageDescription.Product {
        .library(name: name, targets: [name])
    }

    var targetDependency: PackageDescription.Target.Dependency {
        PackageDescription.Target.Dependency(stringLiteral: name)
    }
}

extension ModuleDependency {
    var targetDependency: PackageDescription.Target.Dependency {
        switch self {
        case let .shared(shared):
            shared.targetDependency
        case let .library(library):
            library.targetDependency
        }
    }
}

extension ModuleDependency.SharedDependency {
    var targetDependency: PackageDescription.Target.Dependency {
        .product(name: rawValue, package: "Shared")
    }
}

extension ModuleDependency.LibraryDependency {
    var targetDependency: PackageDescription.Target.Dependency {
        .product(name: rawValue, package: "Library")
    }
}

extension PackageDescription.Target {
    static func target(for module: Module, dependencies: [ModuleDependency]) -> PackageDescription.Target {
        .target(name: module.name, dependencies: dependencies.map(\.targetDependency))
    }

    static func testTarget(for module: Module, dependencies: [ModuleDependency]) -> PackageDescription.Target {
        .testTarget(
            name: module.name + "Tests",
            dependencies: [module.targetDependency] + dependencies.map(\.targetDependency)
        )
    }
}
