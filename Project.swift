import ProjectDescription

let swiftLintScript: TargetScript = .pre(
    script: """
    export PATH="/opt/homebrew/bin:$PATH"

    if which swiftlint >/dev/null; then
    swiftlint --config ${TUIST_ROOT_DIR:-.}/.swiftlint.yml
    else
    echo "warning: SwiftLint not installed"
    fi
    """,
    name: "SwiftLint",
    basedOnDependencyAnalysis: false
)

let project = Project(
    name: "EatPic-iOS",
    settings: .settings(configurations: [
        .debug(name: "Debug", xcconfig: "./EatPic-iOS/Resources/Secrets.xcconfig"), 
        .release(name: "Release", xcconfig: "./EatPic-iOS/Resources/Secrets.xcconfig"), 
    ]),
    targets: [
        .target(
            name: "EatPic-iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.EatPic-iOS",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "NSLocationWhenInUseUsageDescription": "현재 위치 정보를 활용하여 주변 정보를 제공해 드립니다. 위치 권한을 허용하지 않아도 일부 기능을 사용하실 수 있습니다. 원하실 경우, 위치 권한을 허용해 주세요.",
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["EatPic-iOS/Sources/**"],
            resources: ["EatPic-iOS/Resources/**"],
            scripts: [swiftLintScript],
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "Moya"),
                .external(name: "Kingfisher"),
                .external(name: "KakaoSDKUser"),
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
