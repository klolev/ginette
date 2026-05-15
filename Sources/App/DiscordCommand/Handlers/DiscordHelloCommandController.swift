import DiscordBM

struct DiscordHelloCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError { .helloError }
    }

    func on(interaction: Interaction,
            store: GameStore) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.hello.rawValue else {
            return nil
        }

        return .success(.editMessage(.init(content: "ALLÔ MA CHOUETTE!!!")))
    }
}
