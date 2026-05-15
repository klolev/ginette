import DiscordBM

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
                    store: GameStore) async -> Result<Payloads.EditWebhookMessage?, HandlingError> {
        guard let parsedInput = parse(receivedModalInput: modalData).success,
              let guildID else {
            return .failure(.invalidInput)
        }

        let creationController = BingoGameCreationController {
            await store.game(forGuildID: guildID) != nil
        }

        let result = await creationController.create(named: parsedInput.name,
                                                     sized: parsedInput.sheetSize,
                                                     with: parsedInput.tiles,
                                                     inGuildWithID: guildID)

        switch result {
        case .success(let gameDTO):
            await store.save(game: gameDTO)
            return .success(.init(content: "OKIDOU! C'EST PARTI MA CHOUETTE! 💃"))
        case .failure(let error):
            return .failure(.creationError(error))
        }
    }
}

extension DiscordGoCommandController: DiscordInteractionRequestHandler {
    func on(interaction: Interaction,
            store: GameStore) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        switch interaction.data {
        case .applicationCommand(let data):
            guard let subcommand = data.options?.first,
                  subcommand.name == DiscordCommandController.SubcommandType.go.rawValue else {
                return nil
            }

            return .success(.modal(creationRequest))

        case .modalSubmit(let data):
            return await on(modalDataReceived: data, guildID: interaction.guild_id?.rawValue, store: store)
                .map { $0.map(DiscordInteractionResponse.editMessage) }
        default:
            return nil
        }
    }
}
