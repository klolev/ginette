import Vapor
import Fluent
import DiscordBM

struct DiscordFillCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case fillError(BingoGameTileFillController.FillError)
        case invalidInput
        
        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .fillError(self)
        }
    }
    
    private func message(forWins wins: Set<BingoGameTileFillController.Win>.NonEmpty) -> String {
        "*BINGOOOOOOOOO!!!!!!!!!💃✨✨🥳👵💃* " + wins.map { "@\($0.player.name)" }.joined(separator: ", ") + " GAGNENT!!"
    }
    
    func on(interaction: Interaction,
            app: Application) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.fill.rawValue else {
            return nil
        }
        
        guard let guildID = interaction.guild_id,
              case .int(let tileIndex) = subcommand.options?.first?.value else {
            return .failure(.invalidInput)
        }
        
        let controller = BingoGameTileFillController { guildID in
            try await BingoGame.query(on: app.db)
                .with(\.$players)
                .filter(\.$discordGuildID == guildID)
                .first()
                .flatMap { BingoGame.DTO(from: $0, withChildren: true) }
        }
        
        switch await controller.fill(tileWithIndex: UInt(tileIndex), inGameWithGuildID: guildID.rawValue) {
        case .success((let wins, let gameDTO)):
            let game = try await BingoGame.find(gameDTO.id, on: app.db)!
            game.update(with: gameDTO)
            try await game.update(on: app.db)
            
            if let wins = Set<BingoGameTileFillController.Win>.NonEmpty(container: wins) {
                return .success(.editMessage(.init(content: message(forWins: wins))))
            } else {
                return .success(.editMessage(.init(content: "OKIDOU C'EST REMPLI MA BELLE!! ✨")))
            }
        case .failure(let error):
            return .failure(.fillError(error))
        }
    }
}
