import Vapor
import DiscordBM

struct DiscordCommandCreationController {
    static let commandName = "ginette"
    
    typealias Subcommand = DiscordCommandController.SubcommandType
    
    static var command: Payloads.ApplicationCommandCreate {
        .init(
            name: Self.commandName,
            description: "BINGO LES CHOUPIES",
            options: [
                .init(type: .subCommand,
                      name: Subcommand.hello.rawValue,
                      description: "Dis-moi allô!!"),
                .init(type: .subCommand,
                      name: Subcommand.facebook.rawValue,
                      description: "Je t'envoie un mémé de mon Face Book!! Ha Ha"),
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
                      options: [.init(type: .integer, name: "tile_number", description: "Numéro de la case", min_value: .int(0))]),
                .init(type: .subCommand,
                      name: Subcommand.trash.rawValue,
                      description: "Envoie la partie en cours aux poubelles")
            ],
            type: .chatInput
        )
    }
}
