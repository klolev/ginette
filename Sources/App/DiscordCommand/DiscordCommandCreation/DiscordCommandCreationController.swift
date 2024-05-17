import DiscordKit
import Vapor

struct DiscordCommandCreationController {
    static let commandName = "ginette"
    private static let applicationURL = "https://discord.com/api/v10/applications/"
    
    typealias Subcommand = DiscordCommandController.SubcommandType
    
    static var command: DiscordApplicationCommand.Create {
        DiscordApplicationCommand.Create(
            name: Self.commandName,
            description: "BINGO LES CHOUPIES",
            options: [
                .init(type: .subCommand,
                      name: Subcommand.go.rawValue,
                      description: "Part une game de bingo avec tes copains!!"),
                .init(type: .subCommand,
                      name: Subcommand.join.rawValue,
                      description: "Joins toi à la partie en cours"),
                .init(type: .subCommand, 
                      name: Subcommand.sheet.rawValue,
                      description: "Voir ta feuille de bingo"),
                .init(type: .subCommand, 
                      name: Subcommand.tiles.rawValue,
                      description: "Voir la liste des cases avec leurs numéros"),
                .init(type: .subCommand,
                      name: Subcommand.fill.rawValue,
                      description: "Remplis une case dans la partie en cours",
                      options: [.init(type: .integer,
                                      name: "tile_number",
                                      description: "Numéro de la case",
                                      minValue: 0)]),
                .init(type: .subCommand,
                      name: Subcommand.trash.rawValue,
                      description: "Envoie la partie en cours aux poubelles")
            ],
            type: .chatInput
        )
    }
    
    private let applicationID: String
    private let token: String
    
    init(applicationID: String, token: String) {
        self.applicationID = applicationID
        self.token = token
    }
    
    enum CreationError: Error {
        case httpError(UInt)
    }
    
    func create(with client: any Client) async throws {
        let response = try await client.post("\(Self.applicationURL)/\(applicationID)/commands",
                                             headers: ["Authorization": "Bot \(token)"],
                                             beforeSend: { try $0.content.encode(Self.command, using: JSONEncoder()) })
        
        if response.status != .ok {
            throw CreationError.httpError(response.status.code)
        }
    }
}
