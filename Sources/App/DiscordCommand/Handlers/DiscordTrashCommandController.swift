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
            store: GameStore) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.trash.rawValue else {
            return nil
        }

        guard let guildID = interaction.guild_id?.rawValue else {
            return .failure(.invalidInput)
        }

        guard await store.game(forGuildID: guildID) != nil else {
            return .failure(.noGameInProgress)
        }

        await store.delete(gameForGuildID: guildID)

        return .success(.editMessage(.init(content: "Oki c'est aux poubelles 😔😔😔")))
    }
}
