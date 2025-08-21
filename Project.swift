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
    options: .options(
        developmentRegion: "ko"
    ),
    settings: .settings(
        base: [
            "BASE_URL": "$(BASE_URL)",
            "APP_VERSION": "$(APP_VERSION)",
            "APP_BUILD": "$(APP_BUILD)",
            "MARKETING_VERSION": "$(APP_VERSION)",
            "CURRENT_PROJECT_VERSION": "$(APP_BUILD)"
        ],
        configurations: [
            .debug(name: "Debug", xcconfig: "./EatPic-iOS/Resources/Secrets.xcconfig"), 
            .release(name: "Release", xcconfig: "./EatPic-iOS/Resources/Secrets.xcconfig") 
        ]
    ),
    targets: [
        .target(
            name: "EatPic-iOS",
            destinations: [.iPhone],
            product: .app,
            bundleId: "io.tuist.EatPic-iOS.com",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleDevelopmentRegion": "ko",
                    "CFBundleShortVersionString": "$(MARKETING_VERSION)",
                    "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
                    "BASE_URL": "$(BASE_URL)",
                    "NSLocationWhenInUseUsageDescription": "현재 위치 정보를 활용하여 주변 정보를 제공해 드립니다. 위치 권한을 허용하지 않아도 일부 기능을 사용하실 수 있습니다. 원하실 경우, 위치 권한을 허용해 주세요.",
                    "NSCameraUsageDescription": "카메라를 활용하여 사진을 촬영하고 업로드할 수 있습니다.",
                    "NSAppTransportSecurity": [
                        "NSAllowsArbitraryLoads": true
                    ],
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait"
                    ]
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
