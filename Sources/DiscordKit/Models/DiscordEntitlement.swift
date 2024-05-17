import Foundation

public struct DiscordEntitlement: Decodable {
    /// ID of the entitlement
    public let id: String
    
    /// ID of the SKU
    public let skuID: String
    
    /// ID of the parent application
    public let applicationID: String
    
    /// ID of the user that is granted access to the entitlement's sku
    public let userID: String?
    
    /// Type of entitlement
    public let type: Int
    
    /// Entitlement was deleted
    public let deleted: Bool
    
    /// Start date at which the entitlement is valid. Not present when using test entitlements.
    public let startsAt: Date?
    
    /// Date at which the entitlement is no longer valid. Not present when using test entitlements.
    public let endsAt: Date?
    
    /// ID of the guild that is granted access to the entitlement's sku
    public let guildID: String?
    
    /// For consumable items, whether or not the entitlement has been consumed
    public let consumed: Bool?
    
    public init(id: String, skuID: String, applicationID: String, userID: String? = nil, type: Int, deleted: Bool, startsAt: Date? = nil, endsAt: Date? = nil, guildID: String? = nil, consumed: Bool? = nil) {
        self.id = id
        self.skuID = skuID
        self.applicationID = applicationID
        self.userID = userID
        self.type = type
        self.deleted = deleted
        self.startsAt = startsAt
        self.endsAt = endsAt
        self.guildID = guildID
        self.consumed = consumed
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case skuID = "sku_id"
        case applicationID = "application_id"
        case userID = "user_id"
        case type
        case deleted
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case guildID = "guild_id"
        case consumed
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        skuID = try container.decode(String.self, forKey: .skuID)
        applicationID = try container.decode(String.self, forKey: .applicationID)
        userID = try container.decodeIfPresent(String.self, forKey: .userID)
        type = try container.decode(Int.self, forKey: .type)
        deleted = try container.decode(Bool.self, forKey: .deleted)
        startsAt = try container.decodeIfPresent(Date.self, forKey: .startsAt)
        endsAt = try container.decodeIfPresent(Date.self, forKey: .endsAt)
        guildID = try container.decodeIfPresent(String.self, forKey: .guildID)
        consumed = try container.decodeIfPresent(Bool.self, forKey: .consumed)
    }
}
