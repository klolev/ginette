import Vapor
import Fluent
import DiscordKit

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
    
    func on(interaction: DiscordInteraction.Request,
            request: Request) async throws -> Result<DiscordInteraction.Response?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.fill.rawValue else {
            return nil
        }
        
        guard let guildID = interaction.guildID,
              case .integer(let tileIndex) = subcommand.options?.first?.value else {
            return .failure(.invalidInput)
        }
        
        let controller = BingoGameTileFillController { guildID in
            try await BingoGame.query(on: request.db)
                .filter(\.$discordGuildID == guildID)
                .first()
                .flatMap(BingoGame.DTO.init(from:))
        }
        
        switch await controller.fill(tileWithIndex: UInt(tileIndex), inGameWithGuildID: guildID) {
        case .success((let wins, let gameDTO)):
            let game = BingoGame()
            game.update(with: gameDTO)
            try await game.update(on: request.db)
            
            if let wins = Set<BingoGameTileFillController.Win>.NonEmpty(container: wins) {
                return .success(.init(type: .channelMessageWithSource,
                                      data: .init(content: message(forWins: wins))))
            } else {
                return .success(.init(type: .channelMessageWithSource,
                                      data: .init(content: "OKIDOU C'EST REMPLI MA BELLE!! ✨")))
            }
        case .failure(let error):
            return .failure(.fillError(error))
        }
    }
}
