struct BingoGameCreationController {
    enum CreationError: Error, Equatable {
        case invalidSheetSize
        case needMoreTiles(expected: UInt, actual: UInt)
        case guildIsAlreadyPlaying
    }
    
    private let isGuildAlreadyPlaying: () async throws -> Bool
    
    init(isGuildAlreadyPlaying: @escaping () async throws -> Bool) {
        self.isGuildAlreadyPlaying = isGuildAlreadyPlaying
    }
    
    func create(named name: String,
                sized sheetSize: UInt,
                with tiles: [String],
                inGuildWithID guildID: String) async -> Result<BingoGame.DTO, CreationError> {
        guard !((try? await isGuildAlreadyPlaying()) ?? true) else {
            return .failure(.guildIsAlreadyPlaying)
        }
        
        guard sheetSize > 1, sheetSize % 2 == 1 else {
            return .failure(.invalidSheetSize)
        }
        
        let requiredNumberOfTiles = sheetSize * sheetSize
        guard tiles.count >= requiredNumberOfTiles else {
            return .failure(.needMoreTiles(expected: requiredNumberOfTiles, actual: UInt(tiles.count)))
        }
        
        return .success(.init(name: name, discordGuildID: guildID, tiles: tiles, sheetSize: sheetSize))
    }
}
