import Vapor
import DiscordKit

struct DiscordPingCommandController: DiscordInteractionRequestHandler {
    func on(interaction: DiscordInteraction.Request, 
            request: Request) async throws -> Result<DiscordInteraction.Response?, DiscordInteractionHandlerError>? {
        guard interaction.type == .ping else { return nil }
        
        return .success(.init(type: .pong))
    }
}
