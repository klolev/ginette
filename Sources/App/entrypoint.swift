import Vapor
import Logging
import NIOCore
import NIOPosix
import DiscordBM

@main
enum Entrypoint {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        
        let app = try await Application.make(env)
        let bot = await BotGatewayManager(
            token: Environment.process.TOKEN!,
            presence: .init(
                activities: [.init(name: "Bingo", type: .game)],
                status: .online,
                afk: false
            ),
            intents: [.guildMessages, .messageContent]
        )
        
        Task { await bot.connect() }

        // This attempts to install NIO as the Swift Concurrency global executor.
        // You should not call any async functions before this point.
        let executorTakeoverSuccess = NIOSingletons.unsafeTryInstallSingletonPosixEventLoopGroupAsConcurrencyGlobalExecutor()
        app.logger.debug("Running with \(executorTakeoverSuccess ? "SwiftNIO" : "standard") Swift Concurrency default executor")
        
        do {
            try await configure(app)
        } catch {
            app.logger.report(error: error)
            try? await app.asyncShutdown()
            throw error
        }
        
        Task {
            for await event in await bot.events {
                EventHandler(event: event, client: bot.client, app: app).handle()
            }
        }
        
        try await app.execute()
        try await app.asyncShutdown()
    }
}

struct EventHandler: GatewayEventHandler {
    let event: Gateway.Event
    let client: any DiscordClient
    var handler: any DiscordInteractionRequestHandler {
        DiscordCommandController(handlers: [DiscordHelloCommandController(),
                                            DiscordGoCommandController(),
                                            DiscordJoinCommandController(),
                                            DiscordTilesCommandController(),
                                            DiscordFillCommandController(),
                                            DiscordSheetCommandController(),
                                            DiscordMemeCommandController(),
                                            DiscordTrashCommandController()])
    }
    let app: Application

    func onInteractionCreate(_ interaction: Interaction) async throws {
        if (try? interaction.data?.requireApplicationCommand())?.options?.first?.name != DiscordCommandController.SubcommandType.go.rawValue {
            try await client.createInteractionResponse(
                id: interaction.id,
                token: interaction.token,
                payload: .deferredChannelMessageWithSource()
            ).guardSuccess()
        }
        
        let sendMessage = { (payload: Payloads.EditWebhookMessage) in
            try await client.updateOriginalInteractionResponse(token: interaction.token, payload: payload)
        }
        
        switch try await handler.on(interaction: interaction, app: app) {
        case .success(.editMessage(let payload)):
            _ = try await sendMessage(payload).guardSuccess()
        case .success(.modal(let modal)):
            _ = try await client.createInteractionResponse(id: interaction.id,
                                                           token: interaction.token,
                                                           payload: .modal(modal))
            .guardSuccess()
        case .success(.none):
            _ = try await sendMessage(.init(content: "HEIN?")).guardSuccess()
        case .failure(let failure):
            print(failure)
            _ = try await sendMessage(.init(content: "OOPSIE :( \(failure)")).guardSuccess()
        default:
            break
        }
    }
}
