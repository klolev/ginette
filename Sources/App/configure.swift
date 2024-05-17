import Vapor
import Fluent
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) async throws {
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
//    try await BingoDiscordCommandCreationController(applicationID: Environment.process.APPLICATION_ID!,
//                                                    token: Environment.process.TOKEN!)
//    .create(with: app.client)
    try routes(app)
}
