import Foundation
import XCTest
@testable import App

class BingoTileFillControllerTests: XCTestCase {
    func test_fill_invalid_index_tile_gives_an_error() async {
        let game = BingoGame.DTO(name: "test",
                                 discordGuildID: .zero,
                                 tiles: ["a", "b", "c", "d", "e", "f", "g", "h", "i"],
                                 sheetSize: 3)
        let result = await BingoGameTileFillController(getCurrentGameForGuild: { _ in game })
            .fill(tileWithIndex: 9, inGameWithGuildID: .zero)
        
        XCTAssertEqual(result.failure, .invalidIndex)
    }
    
    func test_fill_already_filled_tile_gives_an_error() async {
        let game = BingoGame.DTO(name: "test",
                                 discordGuildID: .zero,
                                 tiles: ["a", "b", "c", "d", "e", "f", "g", "h", "i"],
                                 sheetSize: 3)
        let result1 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in game })
            .fill(tileWithIndex: 0, inGameWithGuildID: .zero)
        let result2 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result1.success!.game })
            .fill(tileWithIndex: 0, inGameWithGuildID: .zero)
        
        XCTAssertEqual(result2.failure, .alreadyFilled)
    }
    
    func test_fill_with_no_players_returns_no_wins() async {
        let game = BingoGame.DTO(name: "test",
                                 discordGuildID: .zero,
                                 tiles: ["a", "b", "c", "d", "e", "f", "g", "h", "i"],
                                 sheetSize: 3)
        let result = await BingoGameTileFillController(getCurrentGameForGuild: { _ in game })
            .fill(tileWithIndex: 0, inGameWithGuildID: .zero)
        
        XCTAssertEqual(result.success?.wins, [])
    }
    
    func test_fill_once_with_one_player_returns_no_wins() async {
        let id = UUID()
        var game = BingoGame.DTO(id: id,
                                 name: "test",
                                 discordGuildID: .zero,
                                 tiles: ["a", "b", "c", "d", "e", "f", "g", "h", "i"],
                                 sheetSize: 3)
        let player = Player.DTO(discordID: .zero, name: .zero, gameID: id, tileIndices: [0, 1, 2, 3, 4, 5, 6, 7, 8])
        game.players.append(player)
        let result = await BingoGameTileFillController(getCurrentGameForGuild: { _ in game })
            .fill(tileWithIndex: 0, inGameWithGuildID: .zero)
        
        XCTAssertEqual(result.success?.wins, [])
    }
    
    func test_fill_diagonal_with_one_player_returns_win() async {
        let id = UUID()
        var game = BingoGame.DTO(id: id,
                                 name: "test",
                                 discordGuildID: .zero,
                                 tiles: ["a", "b", "c", "d", "e", "f", "g", "h", "i"],
                                 sheetSize: 3)
        let player = Player.DTO(discordID: .zero, name: .zero, gameID: id, tileIndices: [0, 1, 2, 3, 4, 5, 6, 7, 8])
        game.players.append(player)
        let result1 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in game })
            .fill(tileWithIndex: 0, inGameWithGuildID: .zero)
        let result2 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result1.success!.game })
            .fill(tileWithIndex: 4, inGameWithGuildID: .zero)
        let result3 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result2.success!.game })
            .fill(tileWithIndex: 8, inGameWithGuildID: .zero)

        XCTAssertEqual(result1.success?.wins, [])
        XCTAssertEqual(result2.success?.wins, [])
        XCTAssertEqual(result3.success?.wins, [.init(player: player, conditions: [.diagonal])!])
    }
    
    func test_fill_diagonal_with_one_player_and_5x5_sheet_returns_win() async {
        let id = UUID()
        var game = BingoGame.DTO(id: id,
                                 name: "test",
                                 discordGuildID: .zero,
                                 tiles: ["a", "b", "c", "d", "e",
                                         "f", "g", "h", "i", "j",
                                         "k", "l", "m", "n", "o",
                                         "p", "q", "r", "s", "t",
                                         "u", "v", "w", "x", "y"],
                                 sheetSize: 5)
        let player = Player.DTO(discordID: .zero, name: .zero, gameID: id, tileIndices: [00, 01, 02, 03, 04,
                                                                                         05, 06, 07, 08, 09,
                                                                                         10, 11, 12, 13, 14,
                                                                                         15, 16, 17, 18, 19,
                                                                                         20, 21, 22, 23, 24])
        game.players.append(player)
        let result1 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in game })
            .fill(tileWithIndex: 0, inGameWithGuildID: .zero)
        let result2 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result1.success!.game })
            .fill(tileWithIndex: 6, inGameWithGuildID: .zero)
        let result3 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result2.success!.game })
            .fill(tileWithIndex: 12, inGameWithGuildID: .zero)
        let result4 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result3.success!.game })
            .fill(tileWithIndex: 18, inGameWithGuildID: .zero)
        let result5 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result4.success!.game })
            .fill(tileWithIndex: 24, inGameWithGuildID: .zero)

        XCTAssertEqual(result1.success?.wins, [])
        XCTAssertEqual(result2.success?.wins, [])
        XCTAssertEqual(result3.success?.wins, [])
        XCTAssertEqual(result4.success?.wins, [])
        XCTAssertEqual(result5.success?.wins, [.init(player: player, conditions: [.diagonal])!])
    }
    
    func test_fill_backwards_diagonal_with_one_player_returns_win() async {
        let id = UUID()
        var game = BingoGame.DTO(id: id,
                                 name: "test",
                                 discordGuildID: .zero,
                                 tiles: ["a", "b", "c", "d", "e", "f", "g", "h", "i"],
                                 sheetSize: 3)
        let player = Player.DTO(discordID: .zero, name: .zero, gameID: id, tileIndices: [0, 1, 2, 3, 4, 5, 6, 7, 8])
        game.players.append(player)
        let result1 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in game })
            .fill(tileWithIndex: 2, inGameWithGuildID: .zero)
        let result2 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result1.success!.game })
            .fill(tileWithIndex: 4, inGameWithGuildID: .zero)
        let result3 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result2.success!.game })
            .fill(tileWithIndex: 6, inGameWithGuildID: .zero)

        XCTAssertEqual(result1.success?.wins, [])
        XCTAssertEqual(result2.success?.wins, [])
        XCTAssertEqual(result3.success?.wins, [.init(player: player, conditions: [.backwardsDiagonal])!])
    }
    
    func test_fill_backwards_diagonal_with_one_player_and_5x5_sheet_returns_win() async {
        let id = UUID()
        var game = BingoGame.DTO(id: id,
                                 name: "test",
                                 discordGuildID: .zero,
                                 tiles: ["a", "b", "c", "d", "e",
                                         "f", "g", "h", "i", "j",
                                         "k", "l", "m", "n", "o",
                                         "p", "q", "r", "s", "t",
                                         "u", "v", "w", "x", "y"],
                                 sheetSize: 5)
        let player = Player.DTO(discordID: .zero, name: .zero, gameID: id, tileIndices: [00, 01, 02, 03, 04,
                                                                                         05, 06, 07, 08, 09,
                                                                                         10, 11, 12, 13, 14,
                                                                                         15, 16, 17, 18, 19,
                                                                                         20, 21, 22, 23, 24])
        game.players.append(player)
        let result1 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in game })
            .fill(tileWithIndex: 24, inGameWithGuildID: .zero)
        let result2 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result1.success!.game })
            .fill(tileWithIndex: 18, inGameWithGuildID: .zero)
        let result3 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result2.success!.game })
            .fill(tileWithIndex: 12, inGameWithGuildID: .zero)
        let result4 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result3.success!.game })
            .fill(tileWithIndex: 06, inGameWithGuildID: .zero)
        let result5 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result4.success!.game })
            .fill(tileWithIndex: 00, inGameWithGuildID: .zero)

        XCTAssertEqual(result1.success?.wins, [])
        XCTAssertEqual(result2.success?.wins, [])
        XCTAssertEqual(result3.success?.wins, [])
        XCTAssertEqual(result4.success?.wins, [])
        XCTAssertEqual(result5.success?.wins, [.init(player: player, conditions: [.diagonal])!])
    }
    
    func test_fill_line_with_one_player_returns_win() async {
        for i in 0..<2 {
            let id = UUID()
            var game = BingoGame.DTO(id: id,
                                     name: "test",
                                     discordGuildID: .zero,
                                     tiles: ["a", "b", "c", "d", "e", "f", "g", "h", "i"],
                                     sheetSize: 3)
            let player = Player.DTO(discordID: .zero, name: .zero, gameID: id, tileIndices: [0, 1, 2, 3, 4, 5, 6, 7, 8])
            game.players.append(player)
            let result1 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in game })
                .fill(tileWithIndex: UInt(i * 3 + 0), inGameWithGuildID: .zero)
            let result2 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result1.success!.game })
                .fill(tileWithIndex: UInt(i * 3 + 1), inGameWithGuildID: .zero)
            let result3 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result2.success!.game })
                .fill(tileWithIndex: UInt(i * 3 + 2), inGameWithGuildID: .zero)
            
            XCTAssertEqual(result1.success?.wins, [])
            XCTAssertEqual(result2.success?.wins, [])
            XCTAssertEqual(result3.success?.wins, [.init(player: player, conditions: [.line(UInt(i))])!])
        }
    }
    
    func test_fill_column_with_one_player_returns_win() async {
        for i in 0..<2 {
            let id = UUID()
            var game = BingoGame.DTO(id: id,
                                     name: "test",
                                     discordGuildID: .zero,
                                     tiles: ["a", "b", "c", "d", "e", "f", "g", "h", "i"],
                                     sheetSize: 3)
            let player = Player.DTO(discordID: .zero, name: .zero, gameID: id, tileIndices: [0, 1, 2, 3, 4, 5, 6, 7, 8])
            game.players.append(player)
            let result1 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in game })
                .fill(tileWithIndex: UInt(i), inGameWithGuildID: .zero)
            let result2 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result1.success!.game })
                .fill(tileWithIndex: UInt(i + 3), inGameWithGuildID: .zero)
            let result3 = await BingoGameTileFillController(getCurrentGameForGuild: { _ in result2.success!.game })
                .fill(tileWithIndex: UInt(i + 6), inGameWithGuildID: .zero)
            
            XCTAssertEqual(result1.success?.wins, [])
            XCTAssertEqual(result2.success?.wins, [])
            XCTAssertEqual(result3.success?.wins, [.init(player: player, conditions: [.column(UInt(i))])!])
        }
    }
}
