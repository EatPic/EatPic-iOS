import ProjectDescription

let project = Project(
    name: "EatPic-iOS",
    targets: [
        .target(
            name: "EatPic-iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.EatPic-iOS",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["EatPic-iOS/Sources/**"],
            resources: ["EatPic-iOS/Resources/**"],
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "Moya"),
            ]
        ),
        .target(
            name: "EatPic-iOSTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.EatPic-iOSTests",
            infoPlist: .default,
            sources: ["EatPic-iOS/Tests/**"],
            resources: [],
            dependencies: [.target(name: "EatPic-iOS")]
        ),
    ]
)
