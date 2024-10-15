import DiscordBM
import Vapor
import Fluent
import BingoSheetSwiftUIPrintService

struct DiscordHelloCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError { .helloError }
    }
    
    func on(interaction: Interaction,
            app: Application) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.hello.rawValue else {
            return nil
        }
        
        return .success(.editMessage(.init(content: "ALLÔ MA CHOUETTE!!!")))
    }
}
