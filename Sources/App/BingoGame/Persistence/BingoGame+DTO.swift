import Foundation

extension BingoGame {
    struct DTO: Equatable {
        let id: UUID?
        let name: String
        let discordGuildID: String
        let tiles: [String]
        let sheetSize: UInt
        var filledTileIndices: Set<UInt>
        var players: [Player.DTO]
        
        init(id: UUID? = nil,
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

extension BingoGame.DTO {
    init(from game: BingoGame, withChildren: Bool) {
        self.id = game.id
        self.name = game.name
        self.discordGuildID = game.discordGuildID
        self.tiles = game.tiles
        self.sheetSize = game.sheetSize
        self.filledTileIndices = game.filledTileIndices
        if withChildren {
            self.players = game.players.map { Player.DTO(from: $0, gameID: try! game.requireID()) }
        } else {
            self.players = []
        }
    }
}
