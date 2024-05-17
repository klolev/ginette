import Foundation

public struct DiscordPermissionOverwrite: Decodable {
    /// role or user id
    public let id: String
    
    /// either 0 (role) or 1 (member)
    public let type: Int
    
    /// permission bit set to allow
    public let allow: String
    
    /// permission bit set to deny
    public let deny: String
    
    public init(id: String, type: Int, allow: String, deny: String) {
        self.id = id
        self.type = type
        self.allow = allow
        self.deny = deny
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case allow
        case deny
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(Int.self, forKey: .type)
        allow = try container.decode(String.self, forKey: .allow)
        deny = try container.decode(String.self, forKey: .deny)
    }
}
