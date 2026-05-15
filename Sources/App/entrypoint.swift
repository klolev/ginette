import Foundation
import DiscordBM

@main
enum Entrypoint {
    static func main() async throws {
        guard let token = ProcessInfo.processInfo.environment["TOKEN"] else {
            fatalError("Missing TOKEN environment variable")
        }

        let store = GameStore()

        let bot = await BotGatewayManager(
            token: token,
            presence: .init(
                activities: [.init(name: "Bingo", type: .game)],
                status: .online,
                afk: false
            ),
            intents: [.guildMessages, .messageContent]
        )

        Task { await bot.connect() }

        try await bot.client
            .bulkSetGlobalApplicationCommands(payload: [DiscordCommandCreationController.command])
            .guardSuccess()

        for await event in await bot.events {
            EventHandler(event: event, client: bot.client, store: store).handle()
        }
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
    let store: GameStore

    func onInteractionCreate(_ interaction: Interaction) async throws {
        if interaction.type == .applicationCommandAutocomplete {
            if case .success(.autocomplete(let autocomplete)) = try await handler.on(interaction: interaction, store: store) {
                _ = try await client.createInteractionResponse(
                    id: interaction.id,
                    token: interaction.token,
                    payload: .autocompleteResult(autocomplete)
                ).guardSuccess()
            }
            return
        }

        let subcommandName = (try? interaction.data?.requireApplicationCommand())?.options?.first?.name
        if subcommandName != DiscordCommandController.SubcommandType.go.rawValue {
            try await client.createInteractionResponse(
                id: interaction.id,
                token: interaction.token,
                payload: .deferredChannelMessageWithSource()
            ).guardSuccess()
        }

        let sendMessage = { (payload: Payloads.EditWebhookMessage) in
            try await client.updateOriginalInteractionResponse(token: interaction.token, payload: payload)
        }

        switch try await handler.on(interaction: interaction, store: store) {
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
