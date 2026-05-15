import Foundation

actor GameStore {
    private let filePath: String
    private var games: [String: BingoGame.DTO] = [:]

    init(filePath: String = "games.json") {
        self.filePath = filePath
        self.games = Self.load(from: filePath)
    }

    func game(forGuildID guildID: String) -> BingoGame.DTO? {
        games[guildID]
    }

    func save(game: BingoGame.DTO) {
        games[game.discordGuildID] = game
        persist()
    }

    func delete(gameForGuildID guildID: String) {
        games.removeValue(forKey: guildID)
        persist()
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(games) else { return }
        try? data.write(to: URL(fileURLWithPath: filePath))
    }

    private static func load(from path: String) -> [String: BingoGame.DTO] {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let games = try? JSONDecoder().decode([String: BingoGame.DTO].self, from: data) else {
            return [:]
        }
        return games
    }
}
