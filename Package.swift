// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "SplitRow",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "SplitRow", targets: ["SplitRow"])
    ],
    dependencies: [
        .package(url: "https://github.com/xmartlabs/Eureka.git", from: "5.3.3")
    ],
    targets: [
        .target(
            name: "SplitRow",
            dependencies: ["Eureka"],
            path: "SplitRow"
        ),
        .testTarget(
            name: "SplitRowTests",
            dependencies: ["SplitRow"],
            path: "SplitRowTests"
        )
    ]
)
