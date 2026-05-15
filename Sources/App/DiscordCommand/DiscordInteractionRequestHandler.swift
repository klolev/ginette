import DiscordBM

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
    case helloError

    var asDiscordInteractionHandlerError: DiscordInteractionHandlerError { self }
}

enum DiscordInteractionResponse {
    case editMessage(Payloads.EditWebhookMessage)
    case modal(Payloads.InteractionResponse.Modal)
    case autocomplete(Payloads.InteractionResponse.Autocomplete)
}

protocol DiscordInteractionRequestHandler {
    associatedtype HandlingError: AsDiscordInteractionHandlerError

    func on(interaction: Interaction,
            store: GameStore) async throws -> Result<DiscordInteractionResponse?, HandlingError>?
}

extension DiscordInteractionRequestHandler {
    func on(interaction: Interaction,
            store: GameStore) async throws -> Result<DiscordInteractionResponse?, DiscordInteractionHandlerError>? {
        try await on(interaction: interaction, store: store)?.mapError(\.asDiscordInteractionHandlerError)
    }
}
