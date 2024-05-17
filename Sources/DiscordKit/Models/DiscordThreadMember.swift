import Foundation

public struct DiscordThreadMember: Decodable {
    /// ID of the thread
    public let id: String?
    
    /// ID of the user
    public let userID: String?
    
    /// Time the user last joined the thread
    public let joinTimestamp: Date
    
    /// Any user-thread settings, currently only used for notifications
    public let flags: Int
    
    /// Additional information about the user
    public let member: DiscordMember?
    
    public init(id: String? = nil, userID: String? = nil, joinTimestamp: Date, flags: Int, member: DiscordMember? = nil) {
        self.id = id
        self.userID = userID
        self.joinTimestamp = joinTimestamp
        self.flags = flags
        self.member = member
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case joinTimestamp = "join_timestamp"
        case flags
        case member
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        userID = try container.decodeIfPresent(String.self, forKey: .userID)
        joinTimestamp = try container.decode(Date.self, forKey: .joinTimestamp)
        flags = try container.decode(Int.self, forKey: .flags)
        member = try container.decodeIfPresent(DiscordMember.self, forKey: .member)
    }
}
