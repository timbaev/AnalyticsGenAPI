import Fluent
import FluentPostgresDriver
import Vapor
import Smtp
import Leaf

// Called before your application initializes.
public func configure(_ app: Application) throws {

    // MARK: - Roter

    try routes(app)

    // MARK: - Middleware

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [
            .accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin
        ]
    )

    let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
    let fileMiddleware = FileMiddleware(publicDirectory: app.directory.publicDirectory)
    let errorMiddleware = ErrorMiddleware.default(environment: app.environment)

    app.middleware.use(corsMiddleware)
    app.middleware.use(fileMiddleware)
    app.middleware.use(errorMiddleware)

    // MARK: - PostgreSQL

    let postgresConfiguration: PostgresConfiguration

    if let rawDatabaseURL = Environment.DATABASE_URL,
       let databaseURL = URL(string: rawDatabaseURL),
       let configuration = PostgresConfiguration(url: databaseURL) {
        postgresConfiguration = configuration
    } else {
        postgresConfiguration = PostgresConfiguration(
            hostname: "127.0.0.1",
            port: 5432,
            username: "postgres",
            password: "qwe",
            database: "analytics_gen"
        )
    }

    app.databases.use(.postgres(configuration: postgresConfiguration), as: .psql)

    // MARK: - Migrations

    app.migrations.add(CreateEvent())
    app.migrations.add(CreateParameter())
    app.migrations.add(CreateTracker())
    app.migrations.add(CreateTrackerEvent())

    // MARK: - SMTP

    app.smtp.configuration.hostname = "smtp.gmail.com"
    app.smtp.configuration.secure = .ssl
    app.smtp.configuration.username = try Environment.smtpEmail()
    app.smtp.configuration.password = try Environment.smtpPassword()

    // MARK: - Leaf

    app.leaf.cache.isEnabled = app.environment.isRelease
}
