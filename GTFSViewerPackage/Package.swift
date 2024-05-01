// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "GTFSViewerPackage",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "GTFSViewerPackage", targets: ["GTFSViewerPackage"]),
        .library(name: "GTFSViewerMap", targets: ["GTFSViewerMap"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kantacky/apis-swift", .upToNextMajor(from: "0.1.0")),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "APIClient",
            dependencies: [
                "GTFSViewerEntity",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "KantackyAPIs", package: "apis-swift"),
            ]
        ),
        .target(name: "GTFSViewerEntity"),
        .target(
            name: "GTFSViewerMap",
            dependencies: [
                "APIClient",
                "GTFSViewerEntity",
                "GTFSViewerUtility",
            ]
        ),
        .target(
            name: "GTFSViewerPackage",
            dependencies: [
                "GTFSViewerMap",
            ]
        ),
        .testTarget(
            name: "GTFSViewerPackageTests",
            dependencies: ["GTFSViewerPackage"]
        ),
        .target(name: "GTFSViewerUtility"),
    ]
)
