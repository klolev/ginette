import DiscordKit
import Vapor
import Fluent

struct DiscordJoinCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case invalidInput
        case joinError(BingoGameJoinController.JoinError)
        
        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .joinError(self)
        }
    }
    
    func on(interaction: DiscordInteraction.Request,
            request: Request) async throws -> Result<DiscordInteraction.Response?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.join.rawValue else {
            return nil
        }
        
        guard let user = interaction.user,
              let guildID = interaction.guildID else {
            return .failure(.invalidInput)
        }
        
        let gameForGuild = { (id: String) async throws -> BingoGame? in
            try await BingoGame.query(on: request.db)
                .filter(\.$discordGuildID == id)
                .first()
        }
        
        let controller = BingoGameJoinController { guildID in
            guard let game = try? await gameForGuild(guildID) else {
                return nil
            }
            
            return BingoGame.DTO(from: game)
        }
        
        let result = await controller
            .join(playerNamed: "\(user.username)#\(user.discriminator)",
                  withDiscordId: user.discriminator,
                  inGuildID: guildID)
        
        switch result {
        case .success:
            return .success(.init(type: .channelMessageWithSource,
                                  data: .init(content: "BIENVENUE DANS LA PARTIE MA CHOUETTE!! ☺️")))
        case .failure(let error):
            return .failure(.joinError(error))
        }
    }
}
