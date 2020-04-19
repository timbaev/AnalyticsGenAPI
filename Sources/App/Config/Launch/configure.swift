import Fluent
import FluentPostgresDriver
import Vapor

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
    let fileMiddleware = FileMiddleware(publicDirectory: "Public")
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
}
