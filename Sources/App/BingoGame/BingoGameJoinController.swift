struct BingoGameJoinController {
    enum JoinError: Error {
        case alreadyInGame
        case noGameInProgress
    }
    
    private let getCurrentGameForGuildID: (String) async throws -> BingoGame.DTO?
    
    init(getCurrentGameForGuildID: @escaping (String) async throws -> BingoGame.DTO?) {
        self.getCurrentGameForGuildID = getCurrentGameForGuildID
    }
    
    func join(playerNamed name: String,
              withDiscordId discordId: String,
              inGuildID guildID: String) async -> Result<Player.DTO, JoinError> {
        guard let game = try? await getCurrentGameForGuildID(guildID) else {
            return .failure(.noGameInProgress)
        }
        
        guard !game.players.map(\.discordID).contains(discordId),
              let gameID = game.id else {
            return .failure(.alreadyInGame)
        }
        
        let numberOfTilesInSheet = Int(game.sheetSize * game.sheetSize)
        let tileIndices = game.tiles.indices.randomSample(count: numberOfTilesInSheet).map { UInt($0) }
        let player = Player.DTO(discordID: discordId,
                                name: name,
                                gameID: gameID,
                                tileIndices: tileIndices)
        
        return .success(player)
    }
}
