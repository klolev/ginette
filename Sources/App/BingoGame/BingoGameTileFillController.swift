import Slingshot

public struct BingoGameTileFillController {
    struct Win: Equatable, Hashable {
        let player: Player.DTO
        let conditions: Set<WinCondition>.NonEmpty
        
        static func == (lhs: Win, rhs: Win) -> Bool {
            lhs.player.id == rhs.player.id
        }
        
        func hash(into hasher: inout Hasher) {
            player.id?.hash(into: &hasher)
        }
        
        init?(player: Player.DTO, conditions: Set<WinCondition>) {
            guard let first = conditions.first else {
                return nil
            }
            self.player = player
            self.conditions = .init(first: first, container: conditions)
        }
    }
    
    enum WinCondition: Equatable, Hashable {
        case diagonal
        case backwardsDiagonal
        case line(UInt)
        case column(UInt)
    }
    
    enum FillError: Error {
        case invalidIndex
        case alreadyFilled
        case noGameInProgress
    }
    
    private let getCurrentGameForGuild: (String) async throws -> BingoGame.DTO?
    
    init(getCurrentGameForGuild: @escaping (String) async throws -> BingoGame.DTO?) {
        self.getCurrentGameForGuild = getCurrentGameForGuild
    }
    
    private func check(sheetIndices: Set<UInt>,
                       withNewlyFilledTile tileIndex: UInt,
                       for player: Player.DTO,
                       in game: BingoGame.DTO) -> Bool {
        let tileIndices = Set(sheetIndices.map { player.tileIndices[Int($0)] })
        
        return tileIndices.contains(tileIndex)
            && game.filledTileIndices.isSuperset(of: tileIndices)
    }
    
    private func check(isDiagonalFilledFor player: Player.DTO,
                       withNewlyFilledTile tileIndex: UInt,
                       in game: BingoGame.DTO) -> Bool {
        check(sheetIndices: Set((0..<game.sheetSize).map { $0 + $0 * game.sheetSize }),
              withNewlyFilledTile: tileIndex,
              for: player,
              in: game)
    }
    
    private func check(isBackwardsDiagonalFilledFor player: Player.DTO,
                       withNewlyFilledTile tileIndex: UInt,
                       in game: BingoGame.DTO) -> Bool {
        check(sheetIndices: Set((0..<game.sheetSize).map { $0 * game.sheetSize + (game.sheetSize - $0 - 1) }),
              withNewlyFilledTile: tileIndex,
              for: player,
              in: game)
    }
    
    private func get(filledLineFor player: Player.DTO,
                     withNewlyFilledTile tileIndex: UInt,
                     in game: BingoGame.DTO) -> UInt? {
        (0..<game.sheetSize)
            .map {
                let start = $0 * game.sheetSize
                return ($0, start..<(start + game.sheetSize))
            }
            .first { _, indices in
                check(sheetIndices: Set(indices),
                      withNewlyFilledTile: tileIndex,
                      for: player,
                      in: game)
            }?.0
    }
    
    private func get(filledColumnFor player: Player.DTO,
                     withNewlyFilledTile tileIndex: UInt,
                     in game: BingoGame.DTO) -> UInt? {
        (0..<game.sheetSize)
            .map { column in
                (column, (0..<game.sheetSize).map { column + $0 * game.sheetSize })
            }
            .first { _, indices in
                check(sheetIndices: Set(indices),
                      withNewlyFilledTile: tileIndex,
                      for: player,
                      in: game)
            }?.0
    }
    
    @SequenceBuilder<Set<WinCondition>>
    private func get(winsFor player: Player.DTO,
                     withNewlyFilledTile tileIndex: UInt,
                     in game: BingoGame.DTO) -> Set<WinCondition> {
        check(isDiagonalFilledFor: player, withNewlyFilledTile: tileIndex, in: game)
            ? WinCondition.diagonal
            : nil
        
        check(isBackwardsDiagonalFilledFor: player, withNewlyFilledTile: tileIndex, in: game)
            ? WinCondition.backwardsDiagonal
            : nil
        
        get(filledLineFor: player, withNewlyFilledTile: tileIndex, in: game)
            .map(WinCondition.line)
        
        get(filledColumnFor: player, withNewlyFilledTile: tileIndex, in: game)
            .map(WinCondition.column)
    }
    
    private func get(winsIn game: BingoGame.DTO, withNewlyFilledTile tileIndex: UInt) -> Set<Win> {
        Set(game.players.compactMap {
            Win(player: $0, conditions: get(winsFor: $0, withNewlyFilledTile: tileIndex, in: game))
        })
    }
    
    func fill(tileWithIndex index: UInt,
              inGameWithGuildID guildID: String) async -> Result<(wins: Set<Win>, game: BingoGame.DTO), FillError> {
        guard var game = try? await getCurrentGameForGuild(guildID) else {
            return .failure(.noGameInProgress)
        }
        
        guard !game.filledTileIndices.contains(index) else {
            return .failure(.alreadyFilled)
        }
        
        guard game.tiles.indices.contains(Int(index)) else {
            return .failure(.invalidIndex)
        }
        
        game.filledTileIndices.insert(index)
        
        return .success((wins: get(winsIn: game, withNewlyFilledTile: index), game: game))
    }
}
