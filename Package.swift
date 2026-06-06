// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "KauMaeAI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "KauMaeCore", targets: ["KauMaeCore"])
    ],
    targets: [
        .target(name: "KauMaeCore"),
        .executableTarget(name: "KauMaeCoreTestRunner", dependencies: ["KauMaeCore"])
    ]
)
