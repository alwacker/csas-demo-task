// swift-tools-version: 6.2

import PackageDescription

// MARK: - Libraries

enum Library: String, CaseIterable {
    case app = "App"
}

// MARK: - Dependencies

enum LibraryDependency {
    enum FeatureDependency: String {
        case account = "Account"
    }

    enum SharedDependency: String {
        case extensions = "SharedExtensions"
        case designSystem = "UIComponents"
        case navigation = "UIKitNavigation"
    }

    enum LibraryDependency: String {
        case networking = "Networking"
        case models = "Models"
        case diContainer = "DIContainer"
        case service = "Service"
    }

    case feature(FeatureDependency)
    case shared(SharedDependency)
    case library(LibraryDependency)
}

// MARK: - Package

let package = Package(
    name: "App",
    platforms: [.iOS(.v26)],
    products: Library.allCases.map(\.library),
    dependencies: [
        .package(path: "../Features"),
        .package(path: "../Shared"),
        .package(path: "../Library")
    ],
    targets: [
        .target(
            for: .app,
            dependencies: [
                .feature(.account),
                .library(.networking),
                .library(.models),
                .library(.diContainer),
                .library(.service),
                .shared(.extensions),
                .shared(.designSystem),
                .shared(.navigation)
            ]
        ),
        .testTarget(
            for: .app,
            dependencies: [
                .feature(.account)
            ]
        )
    ]
)

// MARK: - Sugar

extension Library {
    var name: String { rawValue }

    var library: PackageDescription.Product {
        .library(name: name, targets: [name])
    }

    var targetDependency: PackageDescription.Target.Dependency {
        PackageDescription.Target.Dependency(stringLiteral: name)
    }
}

extension LibraryDependency {
    var targetDependency: PackageDescription.Target.Dependency {
        switch self {
        case let .feature(feature):
            feature.targetDependency
        case let .shared(shared):
            shared.targetDependency
        case let .library(library):
            library.targetDependency
        }
    }
}

extension LibraryDependency.FeatureDependency {
    var targetDependency: PackageDescription.Target.Dependency {
        .product(name: rawValue, package: "Features")
    }
}

extension LibraryDependency.SharedDependency {
    var targetDependency: PackageDescription.Target.Dependency {
        .product(name: rawValue, package: "Shared")
    }
}

extension LibraryDependency.LibraryDependency {
    var targetDependency: PackageDescription.Target.Dependency {
        .product(name: rawValue, package: "Library")
    }
}

extension PackageDescription.Target {
    static func target(for library: Library, dependencies: [LibraryDependency]) -> PackageDescription.Target {
        .target(name: library.name, dependencies: dependencies.map(\.targetDependency))
    }

    static func testTarget(for library: Library, dependencies: [LibraryDependency]) -> PackageDescription.Target {
        .testTarget(
            name: library.name + "Tests",
            dependencies: [library.targetDependency] + dependencies.map(\.targetDependency)
        )
    }
}
