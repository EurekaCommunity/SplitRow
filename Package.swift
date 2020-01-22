// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "SplitRow",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "SplitRow", targets: ["SplitRow"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/xmartlabs/Eureka",
            .revision("88c156b450879a867d4518ecf6d9a269c4cee71a")
        )
    ],
    targets: [
        .target(
            name: "SplitRow",
            path: "SplitRow"
        ),
        .testTarget(
            name: "SplitRowTests",
            dependencies: ["SplitRow"],
            path: "SplitRowTests"
        )
    ]
)
