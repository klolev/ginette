import Foundation
import XCTest
@testable import App

class BingoGameJoinControllerTests: XCTestCase {
    func test_already_joined_error() async {
        let gameID = UUID()
        let playerID = UUID()
        let player = Player.DTO(id: playerID, discordID: "allo", name: "bob", gameID: gameID, tileIndices: [])
        let game = BingoGame.DTO(id: gameID,
                                 name: .zero,
                                 discordGuildID: .zero,
                                 tiles: [],
                                 sheetSize: 3,
                                 players: [player])
        
        let result = await BingoGameJoinController(getCurrentGameForGuildID: { _ in game })
            .join(playerNamed: "bob",
                  withDiscordId: "allo",
                  inGuildID: "")
        
        XCTAssertEqual(result, .failure(.alreadyInGame))
    }
    
    func test_join() async {
        let gameID = UUID()
        let game = BingoGame.DTO(id: gameID, name: .zero, discordGuildID: .zero,
                                 tiles: [.zero, .zero, .zero,
                                         .zero, .zero, .zero,
                                         .zero, .zero, .zero], sheetSize: 3)
        let result = await BingoGameJoinController(getCurrentGameForGuildID: { _ in game })
            .join(playerNamed: "bob",
                  withDiscordId: "allo",
                  inGuildID: .zero)
        
        XCTAssertNotNil(result.success)
        XCTAssertEqual(result.success!.name, "bob")
        XCTAssertEqual(result.success!.discordID, "allo")
        XCTAssertEqual(result.success!.gameID, gameID)
        XCTAssertFalse(result.success!.didBingo)
        XCTAssertEqual(result.success!.tileIndices.count, 9)
        XCTAssertEqual(Set(result.success!.tileIndices), Set(0..<9))
    }
    
    func test_join_more_tiles_than_sheet_size_takes_a_sample() async {
        let gameID = UUID()
        let game = BingoGame.DTO(id: gameID, name: .zero, discordGuildID: .zero,
                                 tiles: [.zero, .zero, .zero, .zero, .zero,
                                         .zero, .zero, .zero, .zero, .zero,
                                         .zero, .zero, .zero, .zero, .zero,
                                         .zero, .zero, .zero, .zero, .zero,
                                         .zero, .zero, .zero, .zero, .zero], sheetSize: 3)
        let result = await BingoGameJoinController(getCurrentGameForGuildID: { _ in game })
            .join(playerNamed: "bob",
                  withDiscordId: "allo",
                  inGuildID: .zero)
        
        XCTAssertNotNil(result.success)
        XCTAssertEqual(result.success!.tileIndices.count, 9)
    }
}
