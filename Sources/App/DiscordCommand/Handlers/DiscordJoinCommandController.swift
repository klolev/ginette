import DiscordBM
import BingoSheetBrowserlessPrintService

struct DiscordJoinCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case invalidInput
        case joinError(BingoGameJoinController.JoinError)

        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .joinError(self)
        }
    }

    func on(interaction: Interaction,
            store: GameStore) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.join.rawValue else {
            return nil
        }

        guard let user = interaction.member?.user,
              let guildID = interaction.guild_id?.rawValue else {
            return .failure(.invalidInput)
        }

        let controller = BingoGameJoinController(getCurrentGameForGuildID: { guildID in
            await store.game(forGuildID: guildID)
        }, printService: BingoSheetBrowserlessPrintService())

        let result = await controller
            .join(playerNamed: interaction.member?.nick ?? user.global_name ?? user.username,
                  withDiscordId: user.id.rawValue,
                  inGuildID: guildID)

        switch result {
        case .success(let result):
            var game = await store.game(forGuildID: guildID)!
            game.players.append(result.player)
            await store.save(game: game)
            return .success(.editMessage(.init(
                content: "BIENVENUE DANS LA PARTIE MA CHOUETTE!! ☺️ <@\(result.player.discordID)>",
                files: [.init(data: .init(data: result.sheet), filename: "sheet.png")]
            )))
        case .failure(let error):
            return .failure(.joinError(error))
        }
    }
}
