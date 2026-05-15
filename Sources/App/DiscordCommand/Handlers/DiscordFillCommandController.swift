import Foundation
import DiscordBM
import NIOCore
import BingoSheetBrowserlessPrintService

struct DiscordFillCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case fillError(BingoGameTileFillController.FillError)
        case invalidInput

        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .fillError(self)
        }
    }

    private func message(forWins wins: Set<BingoGameTileFillController.Win>.NonEmpty) -> String {
        "*BINGOOOOOOOOO!!!!!!!!!💃✨✨🥳👵💃* " + wins.map { "<@\($0.player.discordID)>" }.joined(separator: ", ") + " GAGNENT!!"
    }

    private func autocomplete(interaction: Interaction, store: GameStore) async -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard let guildID = interaction.guild_id?.rawValue,
              let game = await store.game(forGuildID: guildID) else {
            return .success(.autocomplete(.init(choices: [])))
        }

        let subcommand = (try? interaction.data?.requireApplicationCommand())?.options?.first
        let typed = subcommand?.options?.first?.value.flatMap({ v -> String? in
            if case .string(let s) = v { return s }
            return nil
        }) ?? ""

        let choices: [ApplicationCommand.Option.Choice] = game.tiles.enumerated()
            .filter { !game.filledTileIndices.contains(UInt($0.offset)) }
            .filter { typed.isEmpty || $0.element.lowercased().contains(typed.lowercased()) || "\($0.offset)" == typed }
            .prefix(5)
            .map { .init(name: "\($0.offset): \($0.element)", value: .string("\($0.offset)")) }

        return .success(.autocomplete(.init(choices: choices)))
    }

    func on(interaction: Interaction,
            store: GameStore) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        if interaction.type == .applicationCommandAutocomplete {
            guard let subcommand = (try? interaction.data?.requireApplicationCommand())?.options?.first,
                  subcommand.name == DiscordCommandController.SubcommandType.fill.rawValue else {
                return nil
            }
            return await autocomplete(interaction: interaction, store: store)
        }

        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.fill.rawValue else {
            return nil
        }

        guard let guildID = interaction.guild_id,
              case .string(let tileValue) = subcommand.options?.first?.value,
              let tileIndex = UInt(tileValue) else {
            return .failure(.invalidInput)
        }

        let controller = BingoGameTileFillController(getCurrentGameForGuild: { guildID in
            await store.game(forGuildID: guildID)
        }, printService: BingoSheetBrowserlessPrintService())

        switch await controller.fill(tileWithIndex: tileIndex, inGameWithGuildID: guildID.rawValue) {
        case .success(let result):
            await store.save(game: result.game)

            if let wins = Set<BingoGameTileFillController.Win>.NonEmpty(container: result.wins) {
                let path = Bundle.module.path(forResource: "bingo.gif", ofType: nil)!
                let gifData = try Data(contentsOf: URL(fileURLWithPath: path))

                return .success(.editMessage(.init(
                    content: message(forWins: wins),
                    files: [
                        .init(data: ByteBuffer(data: gifData), filename: "bingo.gif")
                    ]
                )))
            } else {
                return .success(
                    .editMessage(.init(
                        content: "OKIDOU! '\(result.filledTile)' EST REMPLI MA BELLE!! ✨ "
                            + result.affectedPlayers.keys.map { "<@\($0.discordID)>" }.joined(separator: ", "),
                        files: result.affectedPlayers.values.map { imageData in
                            .init(data: ByteBuffer(data: imageData), filename: "sheet.png")
                        }
                    ))
                )
            }
        case .failure(let error):
            return .failure(.fillError(error))
        }
    }
}
