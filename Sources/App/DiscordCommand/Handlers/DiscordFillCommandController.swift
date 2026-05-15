import Foundation
import DiscordBM
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

    func on(interaction: Interaction,
            store: GameStore) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.fill.rawValue else {
            return nil
        }

        guard let guildID = interaction.guild_id,
              case .int(let tileIndex) = subcommand.options?.first?.value else {
            return .failure(.invalidInput)
        }

        let controller = BingoGameTileFillController(getCurrentGameForGuild: { guildID in
            await store.game(forGuildID: guildID)
        }, printService: BingoSheetBrowserlessPrintService())

        switch await controller.fill(tileWithIndex: UInt(tileIndex), inGameWithGuildID: guildID.rawValue) {
        case .success(let result):
            await store.save(game: result.game)

            if let wins = Set<BingoGameTileFillController.Win>.NonEmpty(container: result.wins) {
                let path = Bundle.module.path(forResource: "bingo.gif", ofType: nil)!

                return .success(.editMessage(.init(
                    content: message(forWins: wins),
                    files: [
                        .init(data: try! await .init(contentsOf: .init(path), maximumSizeAllowed: .megabytes(8)),
                              filename: "bingo.gif")
                    ]
                )))
            } else {
                return .success(
                    .editMessage(.init(
                        content: "OKIDOU! '\(result.filledTile)' EST REMPLI MA BELLE!! ✨ "
                            + result.affectedPlayers.keys.map { "<@\($0.discordID)>" }.joined(separator: ", "),
                        files: result.affectedPlayers.values.map { imageData in
                            .init(data: ByteBuffer(data: imageData), filename: "sheet.jpeg")
                        }
                    ))
                )
            }
        case .failure(let error):
            return .failure(.fillError(error))
        }
    }
}
