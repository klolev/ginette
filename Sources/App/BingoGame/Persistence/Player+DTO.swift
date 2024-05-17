import Foundation

extension Player {
    struct DTO: Equatable {
        let id: UUID?
        let discordID: String
        let name: String
        let gameID: BingoGame.IDValue
        let tileIndices: [UInt]
        var didBingo: Bool
        
        init(id: UUID? = nil, discordID: String, name: String, gameID: BingoGame.IDValue, tileIndices: [UInt]) {
            self.id = id
            self.discordID = discordID
            self.name = name
            self.gameID = gameID
            self.tileIndices = tileIndices
            self.didBingo = false
        }
    }
}

extension Player.DTO {
    init(from player: Player) {
        self.id = player.id
        self.discordID = player.discordID
        self.name = player.name
        self.gameID = try! player.game.requireID()
        self.tileIndices = player.tileIndices
        self.didBingo = player.didBingo
    }
}
