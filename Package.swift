// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ScreenSaverLauncher",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "ScreenSaverLauncher", targets: ["ScreenSaverLauncher"])
    ],
    dependencies: [
        .package(url: "https://github.com/soffes/HotKey", from: "0.1.3")
    ],
    targets: [
        .executableTarget(
            name: "ScreenSaverLauncher",
            dependencies: ["HotKey"],
            path: ".",
            exclude: [
                "launch-screensaver.sh",
                "ScreenSaverLauncher.iconset",
                "ScreenSaverCLI.swift",
                "build_app.sh",
                "icon_1024x1024.png",
                "generate_icon.sh",
                "Makefile",
                "create_icon.swift",
                "create_screenshot.swift",
                "chatgpt.png",
                "Info.plist",
                "ScreenSaverLauncher.icns",
                "屏幕保护启动器.app",
                "icon_creator",
                "icon_1024x1024_temp.png"
            ],
            resources: [
                .process("README.md")
            ]
        )
    ]
)
