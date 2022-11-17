import ProjectDescription

let organizationName = "br.com.Jaus-Technology"
let project = Project(
    name: "CleanArchitectureMobile",
    organizationName: organizationName,
    settings: nil, 
    targets: [
        Target(
            name: "Domain",
            platform: .macOS,
            product: .framework,
            bundleId: "\(organizationName).domain",
            infoPlist: "Domain/Info.plist",
            sources: ["Domain/Source/**"],
            resources: ["Domain/Resource/**"],
            dependencies: [],
            settings: nil
        )
    ]
)
