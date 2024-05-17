import Fluent

struct InitialMigration: AsyncMigration {
    func revert(on database: any Database) async throws {
        try? await database.schema("players").delete()
        try? await database.schema("games").delete()
    }
    
    func prepare(on database: any Database) async throws {
        try? await database.schema("games")
            .id()
            .field("discord_guild_id", .string)
            .field("name", .string)
            .field("tiles", .array(of: .string))
            .field("sheet_size", .int)
            .field("filled_tile_indices", .array(of: .int))
            .create()

        try await database.schema("players")
            .id()
            .field("discord_id", .string)
            .field("name", .string)
            .field("game_id", .uuid)
            .foreignKey("game_id", references: "games", "id")
            .field("tile_indices", .array(of: .int))
            .field("did_bingo", .bool)
            .create()
    }
}
