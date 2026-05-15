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
        let maxTileLength = max(10, 1900 / max(tiles.count, 1))
        return tiles.enumerated()
            .map { (index, tile) in
                let truncated = tile.value.count > maxTileLength ? String(tile.value.prefix(maxTileLength)) + "…" : tile.value
                let value = "\(index): \(truncated)"
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
            return .success(.editMessage(.init(content: messageContents(fromTiles: tiles))))
        case .failure(let error):
            return .failure(.tilesError(error))
        }
    }
}
