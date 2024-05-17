struct BingoGameTilesController {
    enum TilesError: Error {
        case noGameInProgress
    }
    
    struct Tile {
        let value: String
        let filled: Bool
    }
    
    private let getCurrentGameInGuild: (String) async throws -> BingoGame.DTO?
    
    init(getCurrentGameInGuild: @escaping (String) async throws -> BingoGame.DTO?) {
        self.getCurrentGameInGuild = getCurrentGameInGuild
    }
    
    func get(tilesForGameInGuildWithID guildID: String) async -> Result<[Tile], TilesError> {
        guard let game = try? await getCurrentGameInGuild(guildID) else {
            return .failure(.noGameInProgress)
        }
        
        return .success(game.tiles.enumerated()
            .map { (index, value) in
                .init(value: value, filled: game.filledTileIndices.contains(UInt(index)))
            })
    }
}
