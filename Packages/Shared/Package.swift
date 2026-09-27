// swift-tools-version: 6.2

import PackageDescription

// MARK: - Libraries

enum Library: String, CaseIterable {
    case extensions = "SharedExtensions"
    case designSystem = "UIComponents"
    case navigation = "UIKitNavigation"
}

// MARK: - Dependencies

enum LibraryDependency {
    case library(Library)
    case models
    case localization
}

// MARK: - Package

let package = Package(
    name: "Shared",
    platforms: [.iOS(.v26)],
    products: Library.allCases.map(\.library),
    dependencies: [
        .package(path: "../Library")
    ],
    targets: [
        .target(for: .extensions, dependencies: []),
        .testTarget(for: .extensions, dependencies: []),

        .target(
            for: .designSystem,
            dependencies: [.library(.extensions), .models, .localization],
            resources: [.process("Resources")]
        ),

        .target(for: .navigation, dependencies: [])
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
        case let .library(library):
            library.targetDependency
        case .models:
            .product(name: "Models", package: "Library")
        case .localization:
            .product(name: "Localization", package: "Library")
        }
    }
}

extension PackageDescription.Target {
    static func target(
        for library: Library,
        dependencies: [LibraryDependency],
        resources: [Resource]? = nil
    ) -> PackageDescription.Target {
        .target(
            name: library.name,
            dependencies: dependencies.map(\.targetDependency),
            resources: resources
        )
    }

    static func testTarget(for library: Library, dependencies: [LibraryDependency]) -> PackageDescription.Target {
        .testTarget(
            name: library.name + "Tests",
            dependencies: [library.targetDependency] + dependencies.map(\.targetDependency)
        )
    }
}
