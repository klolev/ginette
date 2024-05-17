import Foundation

public struct DiscordResolvedData: Decodable {
    /// the ids and User objects
    public let users: [String: DiscordUser]?
    
    /// the ids and partial Member objects
    public let members: [String: DiscordMember]?
    
    /// the ids and Role objects
    public let roles: [String: DiscordRole]?
    
    /// the ids and partial Channel objects
    public let channels: [String: DiscordChannel]?
    
    /// the ids and partial Message objects
    public let messages: [String: DiscordMessage]?
    
    /// the ids and attachment objects
    public let attachments: [String: DiscordMessage.Attachment]?
    
    public init(users: [String: DiscordUser]? = nil, members: [String: DiscordMember]? = nil, roles: [String: DiscordRole]? = nil, channels: [String: DiscordChannel]? = nil, messages: [String: DiscordMessage]? = nil, attachments: [String: DiscordMessage.Attachment]? = nil) {
        self.users = users
        self.members = members
        self.roles = roles
        self.channels = channels
        self.messages = messages
        self.attachments = attachments
    }
    
    private enum CodingKeys: String, CodingKey {
        case users
        case members
        case roles
        case channels
        case messages
        case attachments
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        users = try container.decodeIfPresent([String: DiscordUser].self, forKey: .users)
        members = try container.decodeIfPresent([String: DiscordMember].self, forKey: .members)
        roles = try container.decodeIfPresent([String: DiscordRole].self, forKey: .roles)
        channels = try container.decodeIfPresent([String: DiscordChannel].self, forKey: .channels)
        messages = try container.decodeIfPresent([String: DiscordMessage].self, forKey: .messages)
        attachments = try container.decodeIfPresent([String: DiscordMessage.Attachment].self, forKey: .attachments)
    }
}
