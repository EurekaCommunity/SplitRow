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
            url: "https://github.com/AndrewBennet/Eureka",
            .revision("289a917a7b7ddf5c4f043a70f82510ca335461fd")
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
