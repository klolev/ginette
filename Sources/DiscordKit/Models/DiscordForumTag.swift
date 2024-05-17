import Foundation

public struct DiscordForumTag: Decodable {
    /// the id of the tag
    public let id: String
    
    /// the name of the tag (0-20 characters)
    public let name: String
    
    /// whether this tag can only be added to or removed from threads by a member with the MANAGE_THREADS permission
    public let moderated: Bool
    
    /// the id of a guild's custom emoji
    public let emojiID: String?
    
    /// the unicode character of the emoji
    public let emojiName: String?
    
    public init(id: String, name: String, moderated: Bool, emojiID: String? = nil, emojiName: String? = nil) {
        self.id = id
        self.name = name
        self.moderated = moderated
        self.emojiID = emojiID
        self.emojiName = emojiName
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case moderated
        case emojiID = "emoji_id"
        case emojiName = "emoji_name"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        moderated = try container.decode(Bool.self, forKey: .moderated)
        emojiID = try container.decodeIfPresent(String?.self, forKey: .emojiID) ?? nil
        emojiName = try container.decodeIfPresent(String?.self, forKey: .emojiName) ?? nil
    }
}
