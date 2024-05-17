import Foundation

public struct DiscordMember: Decodable {
    /// the user this guild member represents
    public let user: DiscordUser?
    
    /// this user's guild nickname
    public let nick: String?
    
    /// the member's guild avatar hash
    public let avatar: String?
    
    /// array of role object ids
    public let roles: [String]
    
    /// when the user joined the guild
    public let joinedAt: Date
    
    /// when the user started boosting the guild
    public let premiumSince: Date?
    
    /// whether the user is deafened in voice channels
    public let deaf: Bool
    
    /// whether the user is muted in voice channels
    public let mute: Bool
    
    /// guild member flags represented as a bit set, defaults to 0
    public let flags: Int
    
    /// whether the user has not yet passed the guild's Membership Screening requirements
    public let pending: Bool?
    
    /// total permissions of the member in the channel, including overwrites, returned when in the interaction object
    public let permissions: String?
    
    /// when the user's timeout will expire and the user will be able to communicate in the guild again, null or a time in the past if the user is not timed out
    public let communicationDisabledUntil: Date?
    
    public init(user: DiscordUser? = nil, nick: String? = nil, avatar: String? = nil, roles: [String], joinedAt: Date, premiumSince: Date? = nil, deaf: Bool, mute: Bool, flags: Int, pending: Bool? = nil, permissions: String? = nil, communicationDisabledUntil: Date? = nil) {
        self.user = user
        self.nick = nick
        self.avatar = avatar
        self.roles = roles
        self.joinedAt = joinedAt
        self.premiumSince = premiumSince
        self.deaf = deaf
        self.mute = mute
        self.flags = flags
        self.pending = pending
        self.permissions = permissions
        self.communicationDisabledUntil = communicationDisabledUntil
    }
    
    private enum CodingKeys: String, CodingKey {
        case user
        case nick
        case avatar
        case roles
        case joinedAt = "joined_at"
        case premiumSince = "premium_since"
        case deaf
        case mute
        case flags
        case pending
        case permissions
        case communicationDisabledUntil = "communication_disabled_until"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        user = try container.decodeIfPresent(DiscordUser.self, forKey: .user)
        nick = try container.decodeIfPresent(String?.self, forKey: .nick) ?? nil
        avatar = try container.decodeIfPresent(String?.self, forKey: .avatar) ?? nil
        roles = try container.decode([String].self, forKey: .roles)
        joinedAt = try container.decode(Date.self, forKey: .joinedAt)
        premiumSince = try container.decodeIfPresent(Date?.self, forKey: .premiumSince) ?? nil
        deaf = try container.decode(Bool.self, forKey: .deaf)
        mute = try container.decode(Bool.self, forKey: .mute)
        flags = try container.decode(Int.self, forKey: .flags)
        pending = try container.decodeIfPresent(Bool.self, forKey: .pending)
        permissions = try container.decodeIfPresent(String.self, forKey: .permissions)
        communicationDisabledUntil = try container.decodeIfPresent(Date?.self, forKey: .communicationDisabledUntil) ?? nil
    }
}
