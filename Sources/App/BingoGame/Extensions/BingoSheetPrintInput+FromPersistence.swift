import BingoSheetPrintService

extension BingoSheetPrintInput {
    init(fromPlayer player: Player.DTO, inGame game: BingoGame.DTO) {
        self.init(
            gameName: game.name,
            playerName: player.name,
            size: game.sheetSize,
            tiles: player.tileIndices.map {
                BingoSheetPrintInput.Tile(id: String($0),
                                          value: game.tiles[Int($0)],
                                          isFilled: game.filledTileIndices.contains($0))
            }
        )
    }
}
