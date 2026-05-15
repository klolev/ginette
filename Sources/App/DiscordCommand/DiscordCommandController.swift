import DiscordBM

struct DiscordCommandController {
    enum SubcommandType: String {
        case go, join, fill, sheet, facebook, tiles, trash, hello
    }

    private let handlers: [any DiscordInteractionRequestHandler]

    init(handlers: [any DiscordInteractionRequestHandler]) {
        self.handlers = handlers
    }
}

extension DiscordCommandController: DiscordInteractionRequestHandler {
    typealias HandlingError = DiscordInteractionHandlerError

    func on(interaction: Interaction,
            store: GameStore) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        for handler in handlers {
            if let result = try await handler.on(interaction: interaction, store: store) {
                return result
            }
        }

        return nil
    }
}
