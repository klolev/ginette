import DiscordBM

struct DiscordTilesCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case tilesError(BingoGameTilesController.TilesError)
        case invalidInput

        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .tilesError(self)
        }
    }

    private func messageContents(fromTiles tiles: [BingoGameTilesController.Tile]) -> String {
        tiles.enumerated()
            .map { (index, tile) in
                let value = "\(index): \(tile.value)"
                return tile.filled ? "~~\(value)~~" : value
            }
            .joined(separator: "\n")
    }

    func on(interaction: Interaction,
            store: GameStore) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.tiles.rawValue else {
            return nil
        }

        guard let guildID = interaction.guild_id?.rawValue else {
            return .failure(.invalidInput)
        }

        let controller = BingoGameTilesController { guildID in
            await store.game(forGuildID: guildID)
        }

        switch await controller.get(tilesForGameInGuildWithID: guildID) {
        case .success(let tiles):
            let content = messageContents(fromTiles: tiles)
            let embeds = stride(from: 0, to: content.count, by: 4096).map { i in
                let start = content.index(content.startIndex, offsetBy: i)
                let end = content.index(start, offsetBy: min(4096, content.count - i))
                return Embed(description: String(content[start..<end]))
            }
            return .success(.editMessage(.init(embeds: Array(embeds.prefix(10)))))
        case .failure(let error):
            return .failure(.tilesError(error))
        }
    }
}
