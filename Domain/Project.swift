import ProjectDescription


let infoPlist: [String: InfoPlist.Value] = [
    "CFBundleDevelopmentRegion": "$(DEVELOPMENT_LANGUAGE)",
    "CFBundleExecutable": "$(EXECUTABLE_NAME)",
    "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
    "CFBundleInfoDictionaryVersion": "6.0",
    "CFBundleName": "$(PRODUCT_NAME)",
    "CFBundlePackageType": "APPL",
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "LSRequiresIPhoneOS": true,
    "NSHumanReadableCopyright": "Copyright ©. All rights reserved.",
    "Test": "Value",
]

let organizationName = "br.com.Jaus-Technology"
let project = Project(
    name: "Domain",
    targets: [
        Target(
            name: "Domain",
            platform: .macOS,
            product: .framework,
            bundleId: "\(organizationName).domain",
            infoPlist: .default,
            sources: ["Source/**"],
            resources: ["Resource/**"]
        )
    ]
)
