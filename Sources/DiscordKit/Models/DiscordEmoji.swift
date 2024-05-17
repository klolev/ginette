import Foundation

public struct DiscordEmoji: Codable {
    /// emoji id
    public let id: String?
    
    /// emoji name
    public let name: String?
    
    /// roles allowed to use this emoji
    public let roles: [String]?
    
    /// user that created this emoji
    public let user: DiscordUser?
    
    /// whether this emoji must be wrapped in colons
    public let requireColons: Bool?
    
    /// whether this emoji is managed
    public let managed: Bool?
    
    /// whether this emoji is animated
    public let animated: Bool?
    
    /// whether this emoji can be used, may be false due to loss of Server Boosts
    public let available: Bool?
    
    public init(id: String? = nil, name: String? = nil, roles: [String]? = nil, user: DiscordUser? = nil, requireColons: Bool? = nil, managed: Bool? = nil, animated: Bool? = nil, available: Bool? = nil) {
        self.id = id
        self.name = name
        self.roles = roles
        self.user = user
        self.requireColons = requireColons
        self.managed = managed
        self.animated = animated
        self.available = available
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case roles
        case user
        case requireColons = "require_colons"
        case managed
        case animated
        case available
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String?.self, forKey: .id) ?? nil
        name = try container.decodeIfPresent(String?.self, forKey: .name) ?? nil
        roles = try container.decodeIfPresent([String].self, forKey: .roles)
        user = try container.decodeIfPresent(DiscordUser.self, forKey: .user)
        requireColons = try container.decodeIfPresent(Bool.self, forKey: .requireColons)
        managed = try container.decodeIfPresent(Bool.self, forKey: .managed)
        animated = try container.decodeIfPresent(Bool.self, forKey: .animated)
        available = try container.decodeIfPresent(Bool.self, forKey: .available)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name) 
        try container.encodeIfPresent(roles, forKey: .roles)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encodeIfPresent(requireColons, forKey: .requireColons)
        try container.encodeIfPresent(managed, forKey: .managed)
        try container.encodeIfPresent(animated, forKey: .animated)
        try container.encodeIfPresent(available, forKey: .available)
    }
}
