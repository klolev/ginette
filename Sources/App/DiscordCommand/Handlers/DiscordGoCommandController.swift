import DiscordKit
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
    
    private var creationRequest: DiscordInteraction.Response {
        .init(
            type: .modal,
            data: .init(components: [
                .textInput(.init(customID: Field.name.rawValue, style: .short, label: "Nom de la partie")),
                .textInput(.init(customID: Field.tiles.rawValue, style: .paragraph, label: "Cases (une par ligne)")),
                .textInput(.init(customID: Field.size.rawValue, style: .short, label: "Taille des feuilles (impair)"))
            ])
        )
    }
    
    private func get(fieldValueForKey key: String,
                     in data: DiscordInteraction.Request.InteractionData.ModalData.Component) -> String? {
        switch data {
        case .actionRow(let array):
            array.lazy.compactMap { get(fieldValueForKey: key, in: $0) }.first
        case .textInput(let textInputValue):
            textInputValue.customID == key ? textInputValue.value : nil
        }
    }
    
    private func parse(
        receivedModalInput data: DiscordInteraction.Request.InteractionData.ModalData
    ) -> Result<ParsedInput, HandlingError> {
        let fieldValue = { (fieldName: String) -> String? in
            get(fieldValueForKey: fieldName, in: .actionRow(data.components))
        }
        
        guard let name = fieldValue(Field.name.rawValue),
              let tiles = fieldValue(Field.tiles.rawValue)?.split(separator: "\n").map({ String($0) }),
              let sheetSize = fieldValue(Field.size.rawValue).flatMap(UInt.init) else {
            return .failure(.invalidInput)
        }
        
        return .success(.init(name: name, tiles: tiles, sheetSize: sheetSize))
    }
    
    private func on(modalDataReceived modalData: DiscordInteraction.Request.InteractionData.ModalData,
                    guildID: String?,
                    request: Request) async throws -> Result<DiscordInteraction.Response?, HandlingError> {
        guard let parsedInput = parse(receivedModalInput: modalData).success,
              let guildID else {
            return .failure(.invalidInput)
        }
        
        let creationController = BingoGameCreationController {
            try await BingoGame.query(on: request.db)
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
            try await game.update(on: request.db)
            return .success(.init(type: .channelMessageWithSource,
                                  data: .init(content: "OKIDOU! C'EST PARTI MA CHOUETTE! 💃")))
        case .failure(let error):
            return .failure(.creationError(error))
        }
    }
}

extension DiscordGoCommandController: DiscordInteractionRequestHandler {
    func on(interaction: DiscordInteraction.Request, 
            request: Request) async throws -> Result<DiscordInteraction.Response?, HandlingError>? {
        switch interaction.data {
        case .applicationCommand(let data):
            guard let subcommand = data.options?.first,
                  subcommand.name == DiscordCommandController.SubcommandType.go.rawValue else {
                return nil
            }
            
            return .success(creationRequest)
            
        case .modalSubmit(let data):
            return try await on(modalDataReceived: data, guildID: interaction.guildID, request: request)
        default:
            return nil
        }
    }
}
