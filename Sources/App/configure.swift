import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)

    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment.isRelease
    
    let workingDirectory = app.directory.workingDirectory
    app.leaf.configuration.rootDirectory = "/"
    app.leaf.files = ModularViewFiles(workingDirectory: workingDirectory,
                                      fileio: app.fileio)

    // register routes
    let modules: [Module] = [
        // Add modules here
    ]

    for module in modules {
        try module.configure(app)
    }
}