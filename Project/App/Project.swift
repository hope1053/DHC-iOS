import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "App",
  targets: [
    .target(
      name: "Flifin",
      destinations: [.iPhone],
      product: .app,
      productName: "Flifin",
      bundleId: "com.mashup.DHC-iOS",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .extendingDefault(
        with: [
          "UIAppFonts": [
            "WantedSans-Bold.otf",
            "WantedSans-SemiBold.otf",
            "WantedSans-Medium.otf",
            "WantedSans-Regular.otf"
          ],
          "UISupportedInterfaceOrientations": [
            "UIInterfaceOrientationPortrait"
          ],
          "UIUserInterfaceStyle": "Dark",
          "UILaunchScreen": [
            "UIImageName": "splashThumbnail"
          ],
          "NSAppTransportSecurity": [
            "NSAllowsArbitraryLoads": true,
          ],
          "CFBundleShortVersionString": "1.1.0"
        ]
      ),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .external(externalDependency: .alamofire),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .sdWebImageSwiftUI),
        .external(externalDependency: .lottie)
      ],
      settings: .settings(
        base: [
          "DEVELOPMENT_TEAM": "MYR6MP3VKX",
          "CODE_SIGN_STYLE": "Automatic",
          "OTHER_LDFLAGS": "$(inherited) -ObjC -all_load",
        ]
      )
    )
  ],
  resourceSynthesizers: [
    .custom(name: "Fonts", parser: .fonts, extensions: ["otf"]),
  ]
)
