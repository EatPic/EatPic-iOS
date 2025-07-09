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
    targets: [
        .target(
            name: "EatPic-iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.EatPic-iOS",
            deploymentTargets: .iOS("17.0"),
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
