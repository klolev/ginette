import DiscordBM
import Vapor
import Fluent

struct DiscordMemeCommandController: DiscordInteractionRequestHandler {
    enum HandlingError: AsDiscordInteractionHandlerError {
        case apiError
        
        var asDiscordInteractionHandlerError: DiscordInteractionHandlerError {
            .memeError(self)
        }
    }
    
    func on(interaction: Interaction,
            app: Application) async throws -> Result<DiscordInteractionResponse?, HandlingError>? {
        guard case .applicationCommand(let data) = interaction.data,
              let subcommand = data.options?.first,
              subcommand.name == DiscordCommandController.SubcommandType.facebook.rawValue else {
            return nil
        }
        
        let fetcher = RedditMemeFetcher(subreddit: "traaaaaaannnnnnnnnns")
        guard let url = try? await fetcher.fetchRandomMeme() else {
            return .failure(.apiError)
        }
        
        return .success(.editMessage(.init(
            content: "TIENS MA CHOUPETTE J'AI VU ÇA SUR FACE BOOK !! Ha Ha ☺️ \(url)"
        )))
    }
}
