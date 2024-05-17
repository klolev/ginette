import Foundation

public struct DiscordSticker: Decodable {
    /// id of the sticker
    public let id: String
    
    /// for standard stickers, id of the pack the sticker is from
    public let packID: String?
    
    /// name of the sticker
    public let name: String
    
    /// description of the sticker
    public let description: String?
    
    /// autocomplete/suggestion tags for the sticker (max 200 characters)
    public let tags: String
    
    /// Deprecated previously the sticker asset hash, now an empty string
    public let asset: String?
    
    /// type of sticker
    public let type: Int
    
    /// type of sticker format
    public let formatType: Int
    
    /// whether this guild sticker can be used, may be false due to loss of Server Boosts
    public let available: Bool?
    
    /// id of the guild that owns this sticker
    public let guildID: String?
    
    /// the user that uploaded the guild sticker
    public let user: DiscordUser?
    
    /// the standard sticker's sort order within its pack
    public let sortValue: Int?
    
    public init(id: String, name: String, tags: String, type: Int, formatType: Int, description: String? = nil, packID: String? = nil, asset: String? = nil, available: Bool? = nil, guildID: String? = nil, user: DiscordUser? = nil, sortValue: Int? = nil) {
        self.id = id
        self.packID = packID
        self.name = name
        self.description = description
        self.tags = tags
        self.asset = asset
        self.type = type
        self.formatType = formatType
        self.available = available
        self.guildID = guildID
        self.user = user
        self.sortValue = sortValue
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case packID = "pack_id"
        case name
        case description
        case tags
        case asset
        case type
        case formatType = "format_type"
        case available
        case guildID = "guild_id"
        case user
        case sortValue = "sort_value"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        packID = try container.decodeIfPresent(String.self, forKey: .packID)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        tags = try container.decode(String.self, forKey: .tags)
        asset = try container.decodeIfPresent(String.self, forKey: .asset)
        type = try container.decode(Int.self, forKey: .type)
        formatType = try container.decode(Int.self, forKey: .formatType)
        available = try container.decodeIfPresent(Bool.self, forKey: .available)
        guildID = try container.decodeIfPresent(String.self, forKey: .guildID)
        user = try container.decodeIfPresent(DiscordUser.self, forKey: .user)
        sortValue = try container.decodeIfPresent(Int.self, forKey: .sortValue)
    }
}
