// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "cosmos-mlx-image-bridge",
    platforms: [.macOS(.v26)],
    products: [
        .executable(name: "cosmos-mlx-inpaint", targets: ["CosmosMLXInpaint"]),
        .executable(name: "cosmos-mlx-colorize", targets: ["CosmosMLXColorize"]),
    ],
    dependencies: [
        .package(url: "https://github.com/xocialize/mlx-lama-swift", branch: "main"),
        .package(url: "https://github.com/xocialize/mlx-ddcolor-swift", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "CosmosMLXInpaint",
            dependencies: [
                .product(name: "LaMa", package: "mlx-lama-swift"),
                .product(name: "MIGAN", package: "mlx-lama-swift"),
            ]
        ),
        .executableTarget(
            name: "CosmosMLXColorize",
            dependencies: [
                .product(name: "DDColor", package: "mlx-ddcolor-swift"),
            ]
        ),
    ]
)
