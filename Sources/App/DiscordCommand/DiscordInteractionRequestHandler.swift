import DiscordBM
import Vapor

protocol AsDiscordInteractionHandlerError: Error {
    var asDiscordInteractionHandlerError: DiscordInteractionHandlerError { get }
}

enum DiscordInteractionHandlerError: AsDiscordInteractionHandlerError {
    case goError(DiscordGoCommandController.HandlingError)
    case joinError(DiscordJoinCommandController.HandlingError)
    case tilesError(DiscordTilesCommandController.HandlingError)
    case fillError(DiscordFillCommandController.HandlingError)
    case trashError(DiscordTrashCommandController.HandlingError)
    case sheetError(DiscordSheetCommandController.HandlingError)
    case memeError(DiscordMemeCommandController.HandlingError)
//    case messageError(DiscordMessageCommandController.HandlingError)
    case helloError

    var asDiscordInteractionHandlerError: DiscordInteractionHandlerError { self }
}

enum DiscordInteractionResponse {
    case editMessage(Payloads.EditWebhookMessage)
    case modal(Payloads.InteractionResponse.Modal)
}

protocol DiscordInteractionRequestHandler {
    associatedtype HandlingError: AsDiscordInteractionHandlerError
    
    func on(interaction: Interaction,
            app: Application) async throws -> Result<DiscordInteractionResponse?, HandlingError>?
}

extension DiscordInteractionRequestHandler {
    func on(interaction: Interaction,
            app: Application) async throws -> Result<DiscordInteractionResponse?, DiscordInteractionHandlerError>? {
        try await on(interaction: interaction, app: app)?.mapError(\.asDiscordInteractionHandlerError)
    }
}
