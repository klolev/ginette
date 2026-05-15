import DiscordBM

struct DiscordMemeCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case apiError

        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .memeError(self)
        }
    }

    func on(interaction: Interaction,
            store: GameStore) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.facebook.rawValue else {
            return nil
        }

        let text = grandmaTexts.randomElement()!

        return .success(.editMessage(.init(content: text)))
    }
}
