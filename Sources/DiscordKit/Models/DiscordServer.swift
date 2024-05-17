import Foundation

public struct DiscordServer: Decodable {
    /// guild id
    public let id: String
    
    /// guild name (2-100 characters, excluding trailing and leading whitespace)
    public let name: String
    
    /// icon hash
    public let icon: String?
    
    /// icon hash, returned when in the template object
    public let iconHash: String?
    
    /// splash hash
    public let splash: String?
    
    /// discovery splash hash; only present for guilds with the "DISCOVERABLE" feature
    public let discoverySplash: String?
    
    /// true if the user is the owner of the guild
    public let owner: Bool?
    
    /// id of owner
    public let ownerID: String
    
    /// total permissions for the user in the guild (excludes overwrites and implicit permissions)
    public let permissions: String?
    
    /// voice region id for the guild (deprecated)
    public let region: String?
    
    /// id of afk channel
    public let afkChannelID: String?
    
    /// afk timeout in seconds
    public let afkTimeout: Int
    
    /// true if the server widget is enabled
    public let widgetEnabled: Bool?
    
    /// the channel id that the widget will generate an invite to, or null if set to no invite
    public let widgetChannelID: String?
    
    /// verification level required for the guild
    public let verificationLevel: Int
    
    /// default message notifications level
    public let defaultMessageNotifications: Int
    
    /// explicit content filter level
    public let explicitContentFilter: Int
    
    /// roles in the guild
    public let roles: [DiscordRole]
    
    /// custom guild emojis
    public let emojis: [DiscordEmoji]
    
    /// enabled guild features
    public let features: [String]
    
    /// required MFA level for the guild
    public let mfaLevel: Int
    
    /// application id of the guild creator if it is bot-created
    public let applicationID: String?
    
    /// the id of the channel where guild notices such as welcome messages and boost events are posted
    public let systemChannelID: String?
    
    /// system channel flags
    public let systemChannelFlags: Int
    
    /// the id of the channel where Community guilds can display rules and/or guidelines
    public let rulesChannelID: String?
    
    /// the maximum number of presences for the guild (null is always returned, apart from the largest of guilds)
    public let maxPresences: Int?
    
    /// the maximum number of members for the guild
    public let maxMembers: Int?
    
    /// the vanity url code for the guild
    public let vanityURLCode: String?
    
    /// the description of a guild
    public let description: String?
    
    /// banner hash
    public let banner: String?
    
    /// premium tier (Server Boost level)
    public let premiumTier: Int
    
    /// the number of boosts this guild currently has
    public let premiumSubscriptionCount: Int?
    
    /// the preferred locale of a Community guild; used in server discovery and notices from Discord, and sent in interactions; defaults to "en-US"
    public let preferredLocale: String
    
    /// the id of the channel where admins and moderators of Community guilds receive notices from Discord
    public let publicUpdatesChannelID: String?
    
    /// the maximum amount of users in a video channel
    public let maxVideoChannelUsers: Int?
    
    /// the maximum amount of users in a stage video channel
    public let maxStageVideoChannelUsers: Int?
    
    /// approximate number of members in this guild, returned from the GET /guilds/<id> and /users/@me/guilds endpoints when with_counts is true
    public let approximateMemberCount: Int?
    
    /// approximate number of non-offline members in this guild, returned from the GET /guilds/<id> and /users/@me/guilds endpoints when with_counts is true
    public let approximatePresenceCount: Int?
    
    /// the welcome screen of a Community guild, shown to new members, returned in an Invite's guild object
    public let welcomeScreen: WelcomeScreen?
    
    /// guild NSFW level
    public let nsfwLevel: Int
    
    /// custom guild stickers
    public let stickers: [DiscordSticker]?
    
    /// whether the guild has the boost progress bar enabled
    public let premiumProgressBarEnabled: Bool
    
    /// the id of the channel where admins and moderators of Community guilds receive safety alerts from Discord
    public let safetyAlertsChannelID: String?
    
    public init(
        id: String,
        name: String,
        icon: String? = nil,
        iconHash: String? = nil,
        splash: String? = nil,
        discoverySplash: String? = nil,
        owner: Bool? = nil,
        ownerID: String,
        permissions: String? = nil,
        region: String? = nil,
        afkChannelID: String? = nil,
        afkTimeout: Int,
        widgetEnabled: Bool? = nil,
        widgetChannelID: String? = nil,
        verificationLevel: Int,
        defaultMessageNotifications: Int,
        explicitContentFilter: Int,
        roles: [DiscordRole],
        emojis: [DiscordEmoji],
        features: [String],
        mfaLevel: Int,
        applicationID: String? = nil,
        systemChannelID: String? = nil,
        systemChannelFlags: Int,
        rulesChannelID: String? = nil,
        maxPresences: Int? = nil,
        maxMembers: Int? = nil,
        vanityURLCode: String? = nil,
        description: String? = nil,
        banner: String? = nil,
        premiumTier: Int,
        premiumSubscriptionCount: Int? = nil,
        preferredLocale: String,
        publicUpdatesChannelID: String? = nil,
        maxVideoChannelUsers: Int? = nil,
        maxStageVideoChannelUsers: Int? = nil,
        approximateMemberCount: Int? = nil,
        approximatePresenceCount: Int? = nil,
        welcomeScreen: WelcomeScreen? = nil,
        nsfwLevel: Int,
        stickers: [DiscordSticker]? = nil,
        premiumProgressBarEnabled: Bool,
        safetyAlertsChannelID: String? = nil
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.iconHash = iconHash
        self.splash = splash
        self.discoverySplash = discoverySplash
        self.owner = owner
        self.ownerID = ownerID
        self.permissions = permissions
        self.region = region
        self.afkChannelID = afkChannelID
        self.afkTimeout = afkTimeout
        self.widgetEnabled = widgetEnabled
        self.widgetChannelID = widgetChannelID
        self.verificationLevel = verificationLevel
        self.defaultMessageNotifications = defaultMessageNotifications
        self.explicitContentFilter = explicitContentFilter
        self.roles = roles
        self.emojis = emojis
        self.features = features
        self.mfaLevel = mfaLevel
        self.applicationID = applicationID
        self.systemChannelID = systemChannelID
        self.systemChannelFlags = systemChannelFlags
        self.rulesChannelID = rulesChannelID
        self.maxPresences = maxPresences
        self.maxMembers = maxMembers
        self.vanityURLCode = vanityURLCode
        self.description = description
        self.banner = banner
        self.premiumTier = premiumTier
        self.premiumSubscriptionCount = premiumSubscriptionCount
        self.preferredLocale = preferredLocale
        self.publicUpdatesChannelID = publicUpdatesChannelID
        self.maxVideoChannelUsers = maxVideoChannelUsers
        self.maxStageVideoChannelUsers = maxStageVideoChannelUsers
        self.approximateMemberCount = approximateMemberCount
        self.approximatePresenceCount = approximatePresenceCount
        self.welcomeScreen = welcomeScreen
        self.nsfwLevel = nsfwLevel
        self.stickers = stickers
        self.premiumProgressBarEnabled = premiumProgressBarEnabled
        self.safetyAlertsChannelID = safetyAlertsChannelID
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon
        case iconHash = "icon_hash"
        case splash
        case discoverySplash = "discovery_splash"
        case owner
        case ownerID = "owner_id"
        case permissions
        case region
        case afkChannelID = "afk_channel_id"
        case afkTimeout = "afk_timeout"
        case widgetEnabled = "widget_enabled"
        case widgetChannelID = "widget_channel_id"
        case verificationLevel = "verification_level"
        case defaultMessageNotifications = "default_message_notifications"
        case explicitContentFilter = "explicit_content_filter"
        case roles
        case emojis
        case features
        case mfaLevel = "mfa_level"
        case applicationID = "application_id"
        case systemChannelID = "system_channel_id"
        case systemChannelFlags = "system_channel_flags"
        case rulesChannelID = "rules_channel_id"
        case maxPresences = "max_presences"
        case maxMembers = "max_members"
        case vanityURLCode = "vanity_url_code"
        case description
        case banner
        case premiumTier = "premium_tier"
        case premiumSubscriptionCount = "premium_subscription_count"
        case preferredLocale = "preferred_locale"
        case publicUpdatesChannelID = "public_updates_channel_id"
        case maxVideoChannelUsers = "max_video_channel_users"
        case maxStageVideoChannelUsers = "max_stage_video_channel_users"
        case approximateMemberCount = "approximate_member_count"
        case approximatePresenceCount = "approximate_presence_count"
        case welcomeScreen = "welcome_screen"
        case nsfwLevel = "nsfw_level"
        case stickers
        case premiumProgressBarEnabled = "premium_progress_bar_enabled"
        case safetyAlertsChannelID = "safety_alerts_channel_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        icon = try container.decodeIfPresent(String.self, forKey: .icon)
        iconHash = try container.decodeIfPresent(String.self, forKey: .iconHash)
        splash = try container.decodeIfPresent(String.self, forKey: .splash)
        discoverySplash = try container.decodeIfPresent(String.self, forKey: .discoverySplash)
        owner = try container.decodeIfPresent(Bool.self, forKey: .owner)
        ownerID = try container.decode(String.self, forKey: .ownerID)
        permissions = try container.decodeIfPresent(String.self, forKey: .permissions)
        region = try container.decodeIfPresent(String.self, forKey: .region)
        afkChannelID = try container.decodeIfPresent(String.self, forKey: .afkChannelID)
        afkTimeout = try container.decode(Int.self, forKey: .afkTimeout)
        widgetEnabled = try container.decodeIfPresent(Bool.self, forKey: .widgetEnabled)
        widgetChannelID = try container.decodeIfPresent(String.self, forKey: .widgetChannelID)
        verificationLevel = try container.decode(Int.self, forKey: .verificationLevel)
        defaultMessageNotifications = try container.decode(Int.self, forKey: .defaultMessageNotifications)
        explicitContentFilter = try container.decode(Int.self, forKey: .explicitContentFilter)
        roles = try container.decode([DiscordRole].self, forKey: .roles)
        emojis = try container.decode([DiscordEmoji].self, forKey: .emojis)
        features = try container.decode([String].self, forKey: .features)
        mfaLevel = try container.decode(Int.self, forKey: .mfaLevel)
        applicationID = try container.decodeIfPresent(String.self, forKey: .applicationID)
        systemChannelID = try container.decodeIfPresent(String.self, forKey: .systemChannelID)
        systemChannelFlags = try container.decode(Int.self, forKey: .systemChannelFlags)
        rulesChannelID = try container.decodeIfPresent(String.self, forKey: .rulesChannelID)
        maxPresences = try container.decodeIfPresent(Int.self, forKey: .maxPresences)
        maxMembers = try container.decodeIfPresent(Int.self, forKey: .maxMembers)
        vanityURLCode = try container.decodeIfPresent(String.self, forKey: .vanityURLCode)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        banner = try container.decodeIfPresent(String.self, forKey: .banner)
        premiumTier = try container.decode(Int.self, forKey: .premiumTier)
        premiumSubscriptionCount = try container.decodeIfPresent(Int.self, forKey: .premiumSubscriptionCount)
        preferredLocale = try container.decode(String.self, forKey: .preferredLocale)
        publicUpdatesChannelID = try container.decodeIfPresent(String.self, forKey: .publicUpdatesChannelID)
        maxVideoChannelUsers = try container.decodeIfPresent(Int.self, forKey: .maxVideoChannelUsers)
        maxStageVideoChannelUsers = try container.decodeIfPresent(Int.self, forKey: .maxStageVideoChannelUsers)
        approximateMemberCount = try container.decodeIfPresent(Int.self, forKey: .approximateMemberCount)
        approximatePresenceCount = try container.decodeIfPresent(Int.self, forKey: .approximatePresenceCount)
        welcomeScreen = try container.decodeIfPresent(WelcomeScreen.self, forKey: .welcomeScreen)
        nsfwLevel = try container.decode(Int.self, forKey: .nsfwLevel)
        stickers = try container.decodeIfPresent([DiscordSticker].self, forKey: .stickers)
        premiumProgressBarEnabled = try container.decode(Bool.self, forKey: .premiumProgressBarEnabled)
        safetyAlertsChannelID = try container.decodeIfPresent(String.self, forKey: .safetyAlertsChannelID)
    }
    
    public struct WelcomeScreen: Decodable {
        /// the server description shown in the welcome screen
        public let description: String?
        
        /// the channels shown in the welcome screen, up to 5
        public let welcomeChannels: [Channel]
        
        public init(description: String? = nil, welcomeChannels: [Channel]) {
            self.description = description
            self.welcomeChannels = welcomeChannels
        }
        
        private enum CodingKeys: String, CodingKey {
            case description
            case welcomeChannels = "welcome_channels"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            description = try container.decodeIfPresent(String?.self, forKey: .description) ?? nil
            welcomeChannels = try container.decode([Channel].self, forKey: .welcomeChannels)
        }
        
        public struct Channel: Decodable {
            /// the channel's id
            public let channelID: String
            
            /// the description shown for the channel
            public let description: String
            
            /// the emoji id, if the emoji is custom
            public let emojiID: String?
            
            /// the emoji name if custom, the unicode character if standard, or null if no emoji is set
            public let emojiName: String?
            
            public init(channelID: String, description: String, emojiID: String? = nil, emojiName: String? = nil) {
                self.channelID = channelID
                self.description = description
                self.emojiID = emojiID
                self.emojiName = emojiName
            }
            
            private enum CodingKeys: String, CodingKey {
                case channelID = "channel_id"
                case description
                case emojiID = "emoji_id"
                case emojiName = "emoji_name"
            }
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                channelID = try container.decode(String.self, forKey: .channelID)
                description = try container.decode(String.self, forKey: .description)
                emojiID = try container.decodeIfPresent(String?.self, forKey: .emojiID) ?? nil
                emojiName = try container.decodeIfPresent(String?.self, forKey: .emojiName) ?? nil
            }
        }
    }
}
