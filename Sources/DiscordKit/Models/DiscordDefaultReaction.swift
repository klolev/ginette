import Foundation

public struct DiscordDefaultReaction: Decodable {
    /// the id of a guild's custom emoji
    public let emojiID: String?
    
    /// the unicode character of the emoji
    public let emojiName: String?
    
    public init(emojiID: String? = nil, emojiName: String? = nil) {
        self.emojiID = emojiID
        self.emojiName = emojiName
    }
    
    private enum CodingKeys: String, CodingKey {
        case emojiID = "emoji_id"
        case emojiName = "emoji_name"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        emojiID = try container.decodeIfPresent(String?.self, forKey: .emojiID) ?? nil
        emojiName = try container.decodeIfPresent(String?.self, forKey: .emojiName) ?? nil
    }
}
