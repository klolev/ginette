import Foundation
import XCTest
import Slingshot
@testable import App

class BingoGameCreationControllerTests: XCTestCase {
    private func controller(isAlreadyPlaying: Bool = false) -> BingoGameCreationController {
        .init(isGuildAlreadyPlaying: { isAlreadyPlaying })
    }
    
    func test_even_sheet_size_error() async {
        let result = await controller().create(named: .zero,
                                               sized: 4,
                                               with: (0..<16).map(constant(.zero)),
                                               inGuildWithID: .zero)
        XCTAssertEqual(result, .failure(.invalidSheetSize))
    }
    
    func test_sheet_size_lower_than_3_error() async {
        let result = await controller().create(named: .zero,
                                               sized: 1,
                                               with: (0..<16).map(constant(.zero)),
                                               inGuildWithID: .zero)
        XCTAssertEqual(result, .failure(.invalidSheetSize))
    }
    
    func test_sheet_size_too_big_for_number_of_tiles() async {
        let result1 = await controller().create(named: .zero, sized: 3, with: [], inGuildWithID: .zero)
        XCTAssertEqual(result1, .failure(.needMoreTiles(expected: 9, actual: 0)))
        
        let result2 = await controller().create(named: .zero,
                                                sized: 3,
                                                with: (0..<8).map(constant(.zero)),
                                                inGuildWithID: .zero)
        XCTAssertEqual(result2, .failure(.needMoreTiles(expected: 9, actual: 8)))
    }
    
    func test_create_3x3() async {
        let game = await controller().create(named: "bob",
                                             sized: 3,
                                             with: (0..<9).map(constant(.zero)),
                                             inGuildWithID: .zero)
        XCTAssertNotNil(game.success)
        XCTAssertEqual(game.success!.name, "bob")
        XCTAssertEqual(game.success!.sheetSize, 3)
        XCTAssertEqual(game.success!.tiles, (0..<9).map(constant(.zero)))
        XCTAssertTrue(game.success!.filledTileIndices.isEmpty)
        XCTAssertTrue(game.success!.players.isEmpty)
    }
    
    func test_create_5x5() async {
        let game = await controller().create(named: "bob",
                                             sized: 5,
                                             with: (0..<25).map(constant(.zero)),
                                             inGuildWithID: .zero)
        XCTAssertNotNil(game.success)
        XCTAssertEqual(game.success!.name, "bob")
        XCTAssertEqual(game.success!.sheetSize, 5)
        XCTAssertEqual(game.success!.tiles, (0..<25).map(constant(.zero)))
        XCTAssertTrue(game.success!.filledTileIndices.isEmpty)
        XCTAssertTrue(game.success!.players.isEmpty)
    }
    
    func test_already_playing_error() async {
        let result = await controller(isAlreadyPlaying: true)
            .create(named: .zero, sized: 4, with: (0..<16).map(constant(.zero)), inGuildWithID: .zero)
        XCTAssertEqual(result, .failure(.guildIsAlreadyPlaying))
    }
}
