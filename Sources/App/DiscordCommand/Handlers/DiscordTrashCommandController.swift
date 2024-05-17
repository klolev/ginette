import Vapor
import Fluent
import DiscordKit

struct DiscordTrashCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case noGameInProgress
        case invalidInput
        
        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .trashError(self)
        }
    }
    
    func on(interaction: DiscordInteraction.Request,
            request: Request) async throws -> Result<DiscordInteraction.Response?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.trash.rawValue else {
            return nil
        }
        
        guard let guildID = interaction.guildID else {
            return .failure(.invalidInput)
        }
        
        guard let game = try? await BingoGame.query(on: request.db).filter(\.$discordGuildID == guildID).first() else {
            return .failure(.noGameInProgress)
        }
        
        try await game.delete(on: request.db)
        
        return .success(.init(type: .channelMessageWithSource, data: .init(content: "Oki c'est aux poubelles 😔😔😔")))
    }
}
