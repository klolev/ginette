import Foundation

enum BingoGame {
    struct DTO: Codable, Equatable {
        let id: UUID?
        let name: String
        let discordGuildID: String
        let tiles: [String]
        let sheetSize: UInt
        var filledTileIndices: Set<UInt>
        var players: [Player.DTO]

        init(id: UUID? = UUID(),
             name: String,
             discordGuildID: String,
             tiles: [String],
             sheetSize: UInt,
             filledTileIndices: Set<UInt> = [],
             players: [Player.DTO] = []) {
            self.id = id
            self.name = name
            self.discordGuildID = discordGuildID
            self.tiles = tiles
            self.sheetSize = sheetSize
            self.filledTileIndices = filledTileIndices
            self.players = players
        }
    }
}
