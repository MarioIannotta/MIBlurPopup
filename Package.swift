// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MIBlurPopup",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "MIBlurPopup", targets: ["MIBlurPopup"])
    ],
    targets: [
        .target(name: "MIBlurPopup", path: "MIBlurPopup")
    ],
    swiftLanguageVersions: [.v5]
)
