import Foundation
import BingoSheetPrintService

struct BingoGameSheetController {
    enum SheetError: Error {
        case noGameInProgress
        case playerNotInGame
        case printerError(Error)
    }
    
    private let getCurrentGameForGuildID: (String) async throws -> BingoGame.DTO?
    private let printer: BingoSheetPrintService
    
    init(printer: BingoSheetPrintService, getCurrentGameForGuildID: @escaping (String) async throws -> BingoGame.DTO?) {
        self.printer = printer
        self.getCurrentGameForGuildID = getCurrentGameForGuildID
    }
    
    func get(sheetOfPlayerWithID playerID: String, inGuildWithID guildID: String) async -> Result<Data, SheetError> {
        guard let game = try? await getCurrentGameForGuildID(guildID) else {
            return .failure(.noGameInProgress)
        }
        
        guard let player = game.players.first(where: { $0.discordID == playerID }) else {
            return .failure(.playerNotInGame)
        }
        
        let playerTiles = player.tileIndices.map {
            BingoSheetPrintInput.Tile(id: String($0),
                                      value: game.tiles[Int($0)],
                                      isFilled: game.filledTileIndices.contains($0))
        }
        
        do {
            let imageData = try await printer.print(sheet: .init(gameName: game.name,
                                                                 playerName: player.name,
                                                                 size: game.sheetSize,
                                                                 tiles: playerTiles))
            return .success(imageData)
        } catch {
            return .failure(.printerError(error))
        }
    }
}
