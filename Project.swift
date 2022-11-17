import ProjectDescription

let organizationName = "br.com.Jaus-Technology"
let project = Project(
    name: "CleanArchitectureMobile",
    targets: [
        Target(
            name: "Domain",
            platform: .macOS,
            product: .framework,
            bundleId: "\(organizationName).domain",
            infoPlist: "Domain/Resource/",
            sources: ["Domain/Source/**"],
            resources: ["Domain/Resource/**"]
        )
    ]
)
