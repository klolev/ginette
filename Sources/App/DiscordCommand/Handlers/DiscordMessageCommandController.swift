//import DiscordBM
//import Vapor
//import Fluent
//
//struct DiscordMessageCommandController: DiscordInteractionRequestHandler {
//    enum HandlingError: AsDiscordInteractionHandlerError {
//        case assistanceError(Error)
//        case unauthorized
//        
//        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
//            .messageError(self)
//        }
//    }
//    
//    func on(interaction: Interaction,
//            app: Application) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
//        guard case .applicationCommand(let data) = interaction.data,
//              let subcommand = data.options?.first,
//              subcommand.name == DiscordCommandController.SubcommandType.sheet.rawValue else {
//            return nil
//        }
//        
//        guard let user = interaction.member?.user,
//              let guildID = interaction.guild_id?.rawValue else {
//            return .failure(.unauthorized)
//        }
//        
//        
//        
//        switch await controller.get(sheetOfPlayerWithID: user.id.rawValue, inGuildWithID: guildID) {
//        case .success(let imageData):
//            return .success(.editMessage(.init(
//                embeds: [.init(title: "TA FEUILLE",
//                               image: .init(url: .attachment(name: "sheet.png")))],
//                files: [.init(data: ByteBuffer(data: imageData), filename: "sheet.jpeg")]
//            )))
//        case .failure(let error):
//            return .failure(.sheetError(error))
//        }
//    }
//}
