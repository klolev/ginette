import DiscordBM
import Vapor
import Fluent
import BingoSheetSwiftUIPrintService

struct DiscordJoinCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case invalidInput
        case joinError(BingoGameJoinController.JoinError)
        
        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .joinError(self)
        }
    }
    
    func on(interaction: Interaction,
            app: Application) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.join.rawValue else {
            return nil
        }
        
        guard let user = interaction.member?.user,
              let guildID = interaction.guild_id?.rawValue else {
            return .failure(.invalidInput)
        }
        
        let gameForGuild = { (id: String) async throws -> BingoGame? in
            try await BingoGame.query(on: app.db)
                .with(\.$players)
                .filter(\.$discordGuildID == id)
                .first()
        }
        
        let controller = BingoGameJoinController(getCurrentGameForGuildID: { guildID in
            guard let game = try? await gameForGuild(guildID) else {
                return nil
            }
            
            return BingoGame.DTO(from: game, withChildren: true)
        }, printService: BingoSheetSwiftUIPrintService())
        
        let result = await controller
            .join(playerNamed: "\(user.username)#\(user.discriminator)",
                  withDiscordId: user.id.rawValue,
                  inGuildID: guildID)
        
        switch result {
        case .success(let result):
            let player = Player()
            player.update(from: result.player)
            try await player.create(on: app.db)
            return .success(.editMessage(.init(
                content: "BIENVENUE DANS LA PARTIE MA CHOUETTE!! ☺️ <@\(player.discordID)>",
                files: [.init(data: .init(data: result.sheet), filename: "sheet.png")]
            )))
        case .failure(let error):
            return .failure(.joinError(error))
        }
    }
}
