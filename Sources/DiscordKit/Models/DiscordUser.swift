import Foundation

public struct DiscordUser: Codable {
    /// the user's id
    public let id: String
    
    /// the user's username, not unique across the platform
    public let username: String
    
    /// the user's Discord-tag
    public let discriminator: String
    
    /// the user's display name, if it is set. For bots, this is the application name
    public let globalName: String?
    
    /// the user's avatar hash
    public let avatar: String?
    
    /// whether the user belongs to an OAuth2 application
    public let bot: Bool?
    
    /// whether the user is an Official Discord System user (part of the urgent message system)
    public let system: Bool?
    
    /// whether the user has two factor enabled on their account
    public let mfaEnabled: Bool?
    
    /// the user's banner hash
    public let banner: String?
    
    /// the user's banner color encoded as an integer representation of hexadecimal color code
    public let accentColor: Int?
    
    /// the user's chosen language option
    public let locale: String?
    
    /// whether the email on this account has been verified
    public let verified: Bool?
    
    /// the user's email
    public let email: String?
    
    /// the flags on a user's account
    public let flags: Flags?
    
    /// the type of Nitro subscription on a user's account
    public let premiumType: PremiumType?
    
    /// the public flags on a user's account
    public let publicFlags: Flags?
    
    /// the user's avatar decoration hash
    public let avatarDecoration: String?
    
    public init(id: String, username: String, discriminator: String, globalName: String? = nil, avatar: String? = nil, bot: Bool? = nil, system: Bool? = nil, mfaEnabled: Bool? = nil, banner: String? = nil, accentColor: Int? = nil, locale: String? = nil, verified: Bool? = nil, email: String? = nil, flags: Flags? = nil, premiumType: PremiumType? = nil, publicFlags: Flags? = nil, avatarDecoration: String? = nil) {
        self.id = id
        self.username = username
        self.discriminator = discriminator
        self.globalName = globalName
        self.avatar = avatar
        self.bot = bot
        self.system = system
        self.mfaEnabled = mfaEnabled
        self.banner = banner
        self.accentColor = accentColor
        self.locale = locale
        self.verified = verified
        self.email = email
        self.flags = flags
        self.premiumType = premiumType
        self.publicFlags = publicFlags
        self.avatarDecoration = avatarDecoration
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case discriminator
        case globalName = "global_name"
        case avatar
        case bot
        case system
        case mfaEnabled = "mfa_enabled"
        case banner
        case accentColor = "accent_color"
        case locale
        case verified
        case email
        case flags
        case premiumType = "premium_type"
        case publicFlags = "public_flags"
        case avatarDecoration = "avatar_decoration"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        discriminator = try container.decode(String.self, forKey: .discriminator)
        globalName = try container.decodeIfPresent(String.self, forKey: .globalName)
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        bot = try container.decodeIfPresent(Bool.self, forKey: .bot)
        system = try container.decodeIfPresent(Bool.self, forKey: .system)
        mfaEnabled = try container.decodeIfPresent(Bool.self, forKey: .mfaEnabled)
        banner = try container.decodeIfPresent(String?.self, forKey: .banner) ?? nil
        accentColor = try container.decodeIfPresent(Int?.self, forKey: .accentColor) ?? nil
        locale = try container.decodeIfPresent(String.self, forKey: .locale)
        verified = try container.decodeIfPresent(Bool.self, forKey: .verified)
        email = try container.decodeIfPresent(String?.self, forKey: .email) ?? nil
        flags = try container.decodeIfPresent(Flags.self, forKey: .flags)
        premiumType = try container.decodeIfPresent(PremiumType.self, forKey: .premiumType)
        publicFlags = try container.decodeIfPresent(Flags.self, forKey: .publicFlags)
        avatarDecoration = try container.decodeIfPresent(String?.self, forKey: .avatarDecoration) ?? nil
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(discriminator, forKey: .discriminator)
        try container.encodeIfPresent(globalName, forKey: .globalName)
        try container.encodeIfPresent(avatar, forKey: .avatar)
        try container.encodeIfPresent(bot, forKey: .bot)
        try container.encodeIfPresent(system, forKey: .system)
        try container.encodeIfPresent(mfaEnabled, forKey: .mfaEnabled)
        try container.encodeIfPresent(banner, forKey: .banner)
        try container.encodeIfPresent(accentColor, forKey: .accentColor)
        try container.encodeIfPresent(locale, forKey: .locale)
        try container.encodeIfPresent(verified, forKey: .verified)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(flags, forKey: .flags)
        try container.encodeIfPresent(premiumType, forKey: .premiumType)
        try container.encodeIfPresent(publicFlags, forKey: .publicFlags)
        try container.encodeIfPresent(avatarDecoration, forKey: .avatarDecoration)
    }
    
    public enum PremiumType: Int, Codable {
        case none = 0
        case classic = 1
        case nitro = 2
        case basic = 3
    }
    
    public struct Flags: OptionSet, Codable {
        public let rawValue: UInt64
        
        public static let staff = Flags(rawValue: 1 << 0)
        public static let partner = Flags(rawValue: 1 << 1)
        public static let hypesquad = Flags(rawValue: 1 << 2)
        public static let bugHunterLevel1 = Flags(rawValue: 1 << 3)
        public static let houseBravery = Flags(rawValue: 1 << 6)
        public static let houseBrilliance = Flags(rawValue: 1 << 7)
        public static let houseBalance = Flags(rawValue: 1 << 8)
        public static let premiumEarlySupporter = Flags(rawValue: 1 << 9)
        public static let teamPseudoUser = Flags(rawValue: 1 << 10)
        public static let bugHunterLevel2 = Flags(rawValue: 1 << 14)
        public static let verifiedBot = Flags(rawValue: 1 << 16)
        public static let verifiedDeveloper = Flags(rawValue: 1 << 17)
        public static let certifiedModerator = Flags(rawValue: 1 << 18)
        public static let botHttpInteractions = Flags(rawValue: 1 << 19)
        public static let activeDeveloper = Flags(rawValue: 1 << 22)
        
        public init(rawValue: UInt64) {
            self.rawValue = rawValue
        }
    }
}
