import Vapor
import Fluent
import DiscordBM

struct DiscordTrashCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case noGameInProgress
        case invalidInput
        
        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .trashError(self)
        }
    }
    
    func on(interaction: Interaction,
            app: Application) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.trash.rawValue else {
            return nil
        }
        
        guard let guildID = interaction.guild_id?.rawValue else {
            return .failure(.invalidInput)
        }
        
        guard let game = try? await BingoGame.query(on: app.db)
            .with(\.$players)
            .filter(\.$discordGuildID == guildID)
            .first() else {
            return .failure(.noGameInProgress)
        }
        
        try await game.players.delete(on: app.db)
        try await game.delete(on: app.db)
        
        return .success(.editMessage(.init(content: "Oki c'est aux poubelles 😔😔😔")))
    }
}
