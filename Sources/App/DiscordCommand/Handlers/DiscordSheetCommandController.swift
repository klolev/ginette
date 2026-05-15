import DiscordBM
import NIOCore
import BingoSheetBrowserlessPrintService

struct DiscordSheetCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case invalidInput
        case sheetError(BingoGameSheetController.SheetError)

        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .sheetError(self)
        }
    }

    func on(interaction: Interaction,
            store: GameStore) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.sheet.rawValue else {
            return nil
        }

        guard let user = interaction.member?.user,
              let guildID = interaction.guild_id?.rawValue else {
            return .failure(.invalidInput)
        }

        let controller = BingoGameSheetController(printer: BingoSheetBrowserlessPrintService()) { guildID in
            await store.game(forGuildID: guildID)
        }

        switch await controller.get(sheetOfPlayerWithID: user.id.rawValue, inGuildWithID: guildID) {
        case .success(let imageData):
            return .success(.editMessage(.init(
                files: [.init(data: ByteBuffer(data: imageData), filename: "sheet.jpeg")]
            )))
        case .failure(let error):
            return .failure(.sheetError(error))
        }
    }
}
