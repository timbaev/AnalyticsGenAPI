// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "AnalyticsGen",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),

        // 📚 Other third-party libraries
        .package(url: "https://github.com/MihaelIsaev/SwifQL.git", from: "1.0.0"),
        .package(url: "https://github.com/MihaelIsaev/SwifQLVapor.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["Leaf", "Vapor", "FluentPostgreSQL", "SwifQL", "SwifQLVapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

