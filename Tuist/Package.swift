// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "EatPic-iOS",
    dependencies: [
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
        .package(url: "https://github.com/Moya/Moya", .upToNextMajor(from: "15.0.3")),
        .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMajor(from: "5.7.1")),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", .upToNextMajor(from: "2.24.4")),
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "8.3.3")),
    ]
)