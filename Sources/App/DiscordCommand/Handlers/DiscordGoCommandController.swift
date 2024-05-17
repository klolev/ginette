import DiscordBM
import Vapor
import Fluent

struct DiscordGoCommandController {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case invalidInput
        case creationError(BingoGameCreationController.CreationError)
        
        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .goError(self)
        }
    }
    
    private enum Field: String {
        case name, tiles, size
    }
    
    private struct ParsedInput {
        let name: String
        let tiles: [String]
        let sheetSize: UInt
    }
    
    private var creationRequest: Payloads.InteractionResponse.Modal {
        .init(custom_id: "go",
              title: "LETS GO BINGOOO",
              textInputs: [
                .init(custom_id: Field.name.rawValue, style: .short, label: "Nom de la partie"),
                .init(custom_id: Field.tiles.rawValue, style: .paragraph, label: "Cases (une par ligne)"),
                .init(custom_id: Field.size.rawValue, style: .short, label: "Taille des feuilles (impair)")
              ])
    }
    
    private func parse(
        receivedModalInput data: Interaction.ModalSubmit
    ) -> Result<ParsedInput, HandlingError> {
        let fieldValue = { (fieldName: String) -> String? in
            try? data.components
                .requireComponent(customId: fieldName)
                .requireTextInput()
                .value
        }

        guard let name = fieldValue(Field.name.rawValue),
              let tiles = fieldValue(Field.tiles.rawValue)?.split(separator: "\n").map({ String($0) }),
              let sheetSize = fieldValue(Field.size.rawValue).flatMap(UInt.init) else {
            return .failure(.invalidInput)
        }
        
        return .success(.init(name: name, tiles: tiles, sheetSize: sheetSize))
    }
    
    private func on(modalDataReceived modalData: Interaction.ModalSubmit,
                    guildID: String?,
                    app: Application) async throws -> Result<Payloads.EditWebhookMessage?, HandlingError> {
        guard let parsedInput = parse(receivedModalInput: modalData).success,
              let guildID else {
            return .failure(.invalidInput)
        }
        
        let creationController = BingoGameCreationController {
            try await BingoGame.query(on: app.db)
                .filter(\.$discordGuildID == guildID)
                .count() > 0
        }
        
        let result = await creationController.create(named: parsedInput.name,
                                                     sized: parsedInput.sheetSize,
                                                     with: parsedInput.tiles,
                                                     inGuildWithID: guildID)
        
        switch result {
        case .success(let gameDTO):
            let game = BingoGame()
            game.update(with: gameDTO)
            try await game.update(on: app.db)
            return .success(.init(content: "OKIDOU! C'EST PARTI MA CHOUETTE! 💃"))
        case .failure(let error):
            return .failure(.creationError(error))
        }
    }
}

extension DiscordGoCommandController: DiscordInteractionRequestHandler {
    func on(interaction: Interaction, 
            app: Application) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        switch interaction.data {
        case .applicationCommand(let data):
            guard let subcommand = data.options?.first,
                  subcommand.name == DiscordCommandController.SubcommandType.go.rawValue else {
                return nil
            }
            
            return .success(.modal(creationRequest))
            
        case .modalSubmit(let data):
            return try await on(modalDataReceived: data, guildID: interaction.guild_id?.rawValue, app: app)
                .map { $0.map(DiscordInteractionResponse.editMessage) }
        default:
            return nil
        }
    }
}
