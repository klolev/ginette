import Foundation

enum Player {
    struct DTO: Codable, Equatable {
        let id: UUID?
        let discordID: String
        let name: String
        let gameID: UUID?
        let tileIndices: [UInt]
        var didBingo: Bool

        init(id: UUID? = UUID(), discordID: String, name: String, gameID: UUID?, tileIndices: [UInt]) {
            self.id = id
            self.discordID = discordID
            self.name = name
            self.gameID = gameID
            self.tileIndices = tileIndices
            self.didBingo = false
        }
    }
}
