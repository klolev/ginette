import Foundation

public struct DiscordRole: Decodable {
    /// role id
    public let id: String
    
    /// role name
    public let name: String
    
    /// integer representation of hexadecimal color code
    public let color: Int
    
    /// if this role is pinned in the user listing
    public let hoist: Bool
    
    /// role icon hash
    public let icon: String?
    
    /// role unicode emoji
    public let unicodeEmoji: String?
    
    /// position of this role
    public let position: Int
    
    /// permission bit set
    public let permissions: String
    
    /// whether this role is managed by an integration
    public let managed: Bool
    
    /// whether this role is mentionable
    public let mentionable: Bool
    
    /// the tags this role has
    public let tags: Tags?
    
    /// role flags combined as a bitfield
    public let flags: Int
    
    public init(id: String, name: String, color: Int, hoist: Bool, position: Int, permissions: String, managed: Bool, mentionable: Bool, flags: Int, icon: String? = nil, unicodeEmoji: String? = nil, tags: Tags? = nil) {
        self.id = id
        self.name = name
        self.color = color
        self.hoist = hoist
        self.icon = icon
        self.unicodeEmoji = unicodeEmoji
        self.position = position
        self.permissions = permissions
        self.managed = managed
        self.mentionable = mentionable
        self.tags = tags
        self.flags = flags
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
        case hoist
        case icon
        case unicodeEmoji = "unicode_emoji"
        case position
        case permissions
        case managed
        case mentionable
        case tags
        case flags
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        color = try container.decode(Int.self, forKey: .color)
        hoist = try container.decode(Bool.self, forKey: .hoist)
        icon = try container.decodeIfPresent(String?.self, forKey: .icon) ?? nil
        unicodeEmoji = try container.decodeIfPresent(String?.self, forKey: .unicodeEmoji) ?? nil
        position = try container.decode(Int.self, forKey: .position)
        permissions = try container.decode(String.self, forKey: .permissions)
        managed = try container.decode(Bool.self, forKey: .managed)
        mentionable = try container.decode(Bool.self, forKey: .mentionable)
        tags = try container.decodeIfPresent(Tags.self, forKey: .tags)
        flags = try container.decode(Int.self, forKey: .flags)
    }
    
    public struct Tags: Decodable {
        /// the id of the bot this role belongs to
        public let botID: String?
        
        /// the id of the integration this role belongs to
        public let integrationID: String?
        
        /// whether this is the guild's Booster role
        public let premiumSubscriber: Bool?
        
        /// the id of this role's subscription sku and listing
        public let subscriptionListingID: String?
        
        /// whether this role is available for purchase
        public let availableForPurchase: Bool?
        
        /// whether this role is a guild's linked role
        public let guildConnections: Bool?
        
        public init(botID: String? = nil, integrationID: String? = nil, premiumSubscriber: Bool? = nil, subscriptionListingID: String? = nil, availableForPurchase: Bool? = nil, guildConnections: Bool? = nil) {
            self.botID = botID
            self.integrationID = integrationID
            self.premiumSubscriber = premiumSubscriber
            self.subscriptionListingID = subscriptionListingID
            self.availableForPurchase = availableForPurchase
            self.guildConnections = guildConnections
        }
        
        private enum CodingKeys: String, CodingKey {
            case botID = "bot_id"
            case integrationID = "integration_id"
            case premiumSubscriber = "premium_subscriber"
            case subscriptionListingID = "subscription_listing_id"
            case availableForPurchase = "available_for_purchase"
            case guildConnections = "guild_connections"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            botID = try container.decodeIfPresent(String.self, forKey: .botID)
            integrationID = try container.decodeIfPresent(String.self, forKey: .integrationID)
            premiumSubscriber = (try container.decodeIfPresent(Bool?.self, forKey: .premiumSubscriber) ?? nil) != nil ? true : nil
            subscriptionListingID = try container.decodeIfPresent(String.self, forKey: .subscriptionListingID)
            availableForPurchase = (try container.decodeIfPresent(Bool?.self, forKey: .availableForPurchase) ?? nil) != nil ? true : nil
            guildConnections = (try container.decodeIfPresent(Bool?.self, forKey: .guildConnections) ?? nil) != nil ? true : nil
        }
    }

}
