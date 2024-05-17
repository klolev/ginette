import DiscordKit
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

    var asDiscordInteractionHandlerError: DiscordInteractionHandlerError { self }
}

protocol DiscordInteractionRequestHandler {
    associatedtype HandlingError: AsDiscordInteractionHandlerError
    
    func on(interaction: DiscordInteraction.Request,
            request: Request) async throws -> Result<DiscordInteraction.Response?, HandlingError>?
}

extension DiscordInteractionRequestHandler {
    func on(interaction: DiscordInteraction.Request,
            request: Request) async throws -> Result<DiscordInteraction.Response?, DiscordInteractionHandlerError>? {
        try await on(interaction: interaction, request: request)?.mapError(\.asDiscordInteractionHandlerError)
    }
}
