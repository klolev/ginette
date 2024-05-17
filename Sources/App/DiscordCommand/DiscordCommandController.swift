import DiscordKit
import Vapor

struct DiscordCommandController {
    enum SubcommandType: String {
        case go, join, fill, sheet, tiles, trash
    }
    
    private let handlers: [any DiscordInteractionRequestHandler]
    
    init(handlers: [any DiscordInteractionRequestHandler]) {
        self.handlers = handlers
    }
}

extension DiscordCommandController: DiscordInteractionRequestHandler {
    typealias HandlingError = DiscordInteractionHandlerError
    
    func on(interaction: DiscordInteraction.Request,
            request: Request) async throws -> Result<DiscordInteraction.Response?, HandlingError>? {
        for handler in handlers {
            if let result = try await handler.on(interaction: interaction, request: request) {
                return result
            }
        }
        
        return nil
    }
}
