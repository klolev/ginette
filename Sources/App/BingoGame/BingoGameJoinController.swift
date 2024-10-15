import Foundation
import BingoSheetPrintService

struct BingoGameJoinController {
    enum JoinError: Error {
        case alreadyInGame
        case noGameInProgress
        case printError(Error)
    }
    
    private let getCurrentGameForGuildID: (String) async throws -> BingoGame.DTO?
    private let printService: BingoSheetPrintService

    init(getCurrentGameForGuildID: @escaping (String) async throws -> BingoGame.DTO?,
         printService: BingoSheetPrintService) {
        self.getCurrentGameForGuildID = getCurrentGameForGuildID
        self.printService = printService
    }
    
    struct JoinResult {
        let player: Player.DTO
        let sheet: Data
    }
    
    func join(playerNamed name: String,
              withDiscordId discordId: String,
              inGuildID guildID: String) async -> Result<JoinResult, JoinError> {
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
        
        do {
            let sheet = try await printService.print(sheet: .init(fromPlayer: player, inGame: game))
            return .success(.init(player: player, sheet: sheet))
        } catch {
            return .failure(.printError(error))
        }
    }
}
