import Vapor
import Fluent
import FluentSQLiteDriver
import Leaf

// configures your application
public func configure(_ app: Application) async throws {
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    app.migrations.add(InitialMigration())
    app.views.use(.leaf)
    
    try routes(app)
}
