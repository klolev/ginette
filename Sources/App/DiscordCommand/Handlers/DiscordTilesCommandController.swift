import Vapor
import DiscordBM
import Fluent

struct DiscordTilesCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case tilesError(BingoGameTilesController.TilesError)
        case invalidInput
        
        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .tilesError(self)
        }
    }
    
    private func messageContents(fromTiles tiles: [BingoGameTilesController.Tile]) -> String {
        tiles.enumerated()
            .map { (index, tile) in
                let value = "\(index): \(tile.value)"
                return tile.filled ? "~~\(value)~~" : value
            }
            .joined(separator: "\n")
    }
    
    func on(interaction: Interaction,
            app: Application) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.tiles.rawValue else {
            return nil
        }
        
        guard let guildID = interaction.guild_id?.rawValue else {
            return .failure(.invalidInput)
        }
        
        let controller = BingoGameTilesController { guildID in
            try await BingoGame.query(on: app.db)
                .filter(\.$discordGuildID == guildID)
                .first()
                .flatMap(BingoGame.DTO.init(from:))
        }
        
        switch await controller.get(tilesForGameInGuildWithID: guildID) {
        case .success(let tiles):
            return .success(.editMessage(.init(content: messageContents(fromTiles: tiles))))
        case .failure(let error):
            return .failure(.tilesError(error))
        }
    }
}
