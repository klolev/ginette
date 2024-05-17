import Foundation
import Fluent

final class BingoGame: Model {
    static let schema: String = "games"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "discord_guild_id")
    var discordGuildID: String

    @Field(key: "name")
    var name: String
    
    @Field(key: "tiles")
    var tiles: [String]
    
    @Field(key: "sheet_size")
    var sheetSize: UInt
    
    @Field(key: "filled_tile_indices")
    var filledTileIndices: Set<UInt>
    
    @Children(for: \.$game)
    var players: [Player]
    
    init() {}
}

extension BingoGame {
    func update(with dto: DTO) {
        self.id = dto.id
        self.discordGuildID = dto.discordGuildID
        self.name = dto.name
        self.tiles = dto.tiles
        self.sheetSize = dto.sheetSize
        self.filledTileIndices = dto.filledTileIndices
    }
}
