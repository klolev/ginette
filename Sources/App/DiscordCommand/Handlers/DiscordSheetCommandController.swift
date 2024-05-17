import DiscordKit
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
    
    func on(interaction: DiscordInteraction.Request,
            request: Request) async throws -> Result<DiscordInteraction.Response?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.sheet.rawValue else {
            return nil
        }
        
        guard let user = interaction.user,
              let guildID = interaction.guildID else {
            return .failure(.invalidInput)
        }
        
        let gameForGuild = { (id: String) async throws -> BingoGame? in
            try await BingoGame.query(on: request.db)
                .filter(\.$discordGuildID == id)
                .first()
        }
        
        let controller = BingoGameSheetController(printer: BingoSheetSwiftUIPrintService()) { guildID in
            guard let game = try? await gameForGuild(guildID) else {
                return nil
            }
            
            return BingoGame.DTO(from: game)
        }
        
        switch await controller.get(sheetOfPlayerWithID: user.id, inGuildWithID: guildID) {
        case .success(let imageData):
            return .success(.init(type: .channelMessageWithSource,
                                  data: .init(content: "data:image/jpeg;base64,\(imageData.base64EncodedString())")))
        case .failure(let error):
            return .failure(.sheetError(error))
        }
    }
}
