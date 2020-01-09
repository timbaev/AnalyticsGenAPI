import Leaf
import Vapor
import FluentPostgreSQL

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {

    // MARK: - Roter

    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // MARK: - Middleware

    var middleware = MiddlewareConfig()

    middleware.use(ErrorMiddleware.self)

    services.register(middleware)

    // MARK: - PostgreSQL

    try services.register(FluentPostgreSQLProvider())

    let databaseName = (env == .testing) ? "analytics_gen_test" : "analytics_gen"

    let postgresqlConfig: PostgreSQLDatabaseConfig

    if let databaseURL = Environment.DATABASE_URL {
        guard let config = PostgreSQLDatabaseConfig(url: databaseURL) else {
            throw Abort(.internalServerError, reason: "Incorrect database URL")
        }

        postgresqlConfig = config
    } else {
        postgresqlConfig = PostgreSQLDatabaseConfig(
            hostname: "127.0.0.1",
            port: 5432,
            username: "postgres",
            database: databaseName,
            password: "qwe"
        )
    }

    let postgres = PostgreSQLDatabase(config: postgresqlConfig)

    var databases = DatabasesConfig()

    databases.enableLogging(on: .psql)
    databases.add(database: postgres, as: .psql)

    services.register(databases)

    // MARK: - Migrations

    var migrations = MigrationConfig()

    migrations.add(model: AnalyticsTracker.self, database: .psql)
    migrations.add(model: AnalyticsEvent.self, database: .psql)
    migrations.add(model: AnalyticsParameter.self, database: .psql)
    migrations.add(model: AnalyticsTrackerEvent.self, database: .psql)

    services.register(migrations)

    // MARK: - Commands

    var commands = CommandConfig.default()
    commands.useFluentCommands()

    services.register(commands)

    // MARK: - NIOServerConfig

    services.register(NIOServerConfig.default(maxBodySize: 20_000_000))
}
