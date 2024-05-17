import Foundation
import Fluent

final class Player: Model {
    static let schema: String = "players"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "discord_id")
    var discordID: String
    
    @Field(key: "name")
    var name: String
    
    @Parent(key: "game_id")
    var game: BingoGame
    
    @Field(key: "tile_indices")
    var tileIndices: [UInt]
    
    @Field(key: "did_bingo")
    var didBingo: Bool
    
    init() {}
}

extension Player {
    func update(from dto: DTO) {
        self.id = dto.id
        self.discordID = dto.discordID
        self.name = dto.name
        self._game.id = dto.gameID
        self.tileIndices = dto.tileIndices
        self.didBingo = dto.didBingo
    }
}
