import Foundation
import BingoSheetSwiftUIPrintService
import Vapor
import Fluent
import Leaf

struct Context: Encodable {
    let gameName: String
    let sheets: [String]
}

func routes(_ app: Application) throws {
    app.get("game", ":uuid") { req async throws -> View in
        guard let uuidString = req.parameters.get("uuid"),
              let game = try await BingoGame.query(on: req.db).with(\.$players).filter(\.$discordGuildID == uuidString).first() else {
            throw Abort(.notFound)
        }
        
        let controller = BingoGameSheetController(printer: BingoSheetSwiftUIPrintService(),
                                                  getCurrentGameForGuildID: { _ in .init(from: game, withChildren: true) })
        var sheets: [String] = []
        for player in game.players {
            let result = await controller.get(sheetOfPlayerWithID: player.discordID, inGuildWithID: uuidString)
            if let sheet = result.success {
                sheets.append(sheet.base64EncodedString())
            }
        }
        
        return try await req.view.render("game", Context(gameName: game.name, sheets: sheets))
    }
}
