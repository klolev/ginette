import DiscordBM
import Vapor
import Fluent
import BingoSheetSwiftUIPrintService

struct DiscordSheetCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case invalidInput
        case sheetError(BingoGameSheetController.SheetError)
        
        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .sheetError(self)
        }
    }
    
    func on(interaction: Interaction,
            app: Application) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.sheet.rawValue else {
            return nil
        }
        
        guard let user = interaction.member?.user,
              let guildID = interaction.guild_id?.rawValue else {
            return .failure(.invalidInput)
        }
        
        let gameForGuild = { (id: String) async throws -> BingoGame? in
            try await BingoGame.query(on: app.db)
                .with(\.$players)
                .filter(\.$discordGuildID == id)
                .first()
        }
        
        let controller = BingoGameSheetController(printer: BingoSheetSwiftUIPrintService()) { guildID in
            guard let game = try? await gameForGuild(guildID) else {
                return nil
            }
            
            return BingoGame.DTO(from: game, withChildren: true)
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
