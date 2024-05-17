import Foundation

public struct DiscordChannel: Decodable {
    /// the id of this channel
    public let id: String
    
    /// the type of channel
    public let type: ChannelType
    
    /// the id of the guild (may be missing for some channel objects received over gateway guild dispatches)
    public let guildID: String?
    
    /// sorting position of the channel
    public let position: Int?
    
    /// explicit permission overwrites for members and roles
    public let permissionOverwrites: [DiscordPermissionOverwrite]?
    
    /// the name of the channel (1-100 characters)
    public let name: String?
    
    /// the channel topic (0-4096 characters for GUILD_FORUM and GUILD_MEDIA channels, 0-1024 characters for all others)
    public let topic: String?
    
    /// whether the channel is nsfw
    public let nsfw: Bool?
    
    /// the id of the last message sent in this channel (or thread for GUILD_FORUM or GUILD_MEDIA channels) (may not point to an existing or valid message or thread)
    public let lastMessageID: String?
    
    /// the bitrate (in bits) of the voice channel
    public let bitrate: Int?
    
    /// the user limit of the voice channel
    public let userLimit: Int?
    
    /// amount of seconds a user has to wait before sending another message (0-21600); bots, as well as users with the permission manage_messages or manage_channel, are unaffected
    public let rateLimitPerUser: Int?
    
    /// the recipients of the DM
    public let recipients: [DiscordUser]?
    
    /// icon hash of the group DM
    public let icon: String?
    
    /// id of the creator of the group DM or thread
    public let ownerID: String?
    
    /// application id of the group DM creator if it is bot-created
    public let applicationID: String?
    
    /// for group DM channels: whether the channel is managed by an application via the gdm.join OAuth2 scope
    public let managed: Bool?
    
    /// for guild channels: id of the parent category for a channel (each parent category can contain up to 50 channels), for threads: id of the text channel this thread was created
    public let parentID: String?
    
    /// when the last pinned message was pinned. This may be null in events such as GUILD_CREATE when a message is not pinned.
    public let lastPinTimestamp: Date?
    
    /// voice region id for the voice channel, automatic when set to null
    public let rtcRegion: String?
    
    /// the camera video quality mode of the voice channel, 1 when not present
    public let videoQualityMode: Int?
    
    /// number of messages (not including the initial message or deleted messages) in a thread.
    public let messageCount: Int?
    
    /// an approximate count of users in a thread, stops counting at 50
    public let memberCount: Int?
    
    /// thread-specific fields not needed by other channels
    public let threadMetadata: DiscordThreadMetadata?
    
    /// thread member object for the current user, if they have joined the thread, only included on certain API endpoints
    public let member: DiscordThreadMember?
    
    /// default duration, copied onto newly created threads, in minutes, threads will stop showing in the channel list after the specified period of inactivity, can be set to: 60, 1440, 4320, 10080
    public let defaultAutoArchiveDuration: Int?
    
    /// computed permissions for the invoking user in the channel, including overwrites, only included when part of the resolved data received on a slash command interaction. This does not include implicit permissions, which may need to be checked separately
    public let permissions: String?
    
    /// channel flags combined as a bitfield
    public let flags: Flags?
    
    /// number of messages ever sent in a thread, it's similar to message_count on message creation, but will not decrement the number when a message is deleted
    public let totalMessageSent: Int?
    
    /// the set of tags that can be used in a GUILD_FORUM or a GUILD_MEDIA channel
    public let availableTags: [DiscordForumTag]?
    
    /// the IDs of the set of tags that have been applied to a thread in a GUILD_FORUM or a GUILD_MEDIA channel
    public let appliedTags: [String]?
    
    /// the emoji to show in the add reaction button on a thread in a GUILD_FORUM or a GUILD_MEDIA channel
    public let defaultReactionEmoji: DiscordDefaultReaction?
    
    /// the initial rate_limit_per_user to set on newly created threads in a channel. this field is copied to the thread at creation time and does not live update.
    public let defaultThreadRateLimitPerUser: Int?
    
    /// the default sort order type used to order posts in GUILD_FORUM and GUILD_MEDIA channels. Defaults to null, which indicates a preferred sort order hasn't been set by a channel admin
    public let defaultSortOrder: Int?
    
    /// the default forum layout view used to display posts in GUILD_FORUM channels. Defaults to 0, which indicates a layout view has not been set by a channel admin
    public let defaultForumLayout: Int?
    
    public init(id: String, type: ChannelType, guildID: String? = nil, position: Int? = nil, permissionOverwrites: [DiscordPermissionOverwrite]? = nil, name: String? = nil, topic: String? = nil, nsfw: Bool? = nil, lastMessageID: String? = nil, bitrate: Int? = nil, userLimit: Int? = nil, rateLimitPerUser: Int? = nil, recipients: [DiscordUser]? = nil, icon: String? = nil, ownerID: String? = nil, applicationID: String? = nil, managed: Bool? = nil, parentID: String? = nil, lastPinTimestamp: Date? = nil, rtcRegion: String? = nil, videoQualityMode: Int? = nil, messageCount: Int? = nil, memberCount: Int? = nil, threadMetadata: DiscordThreadMetadata? = nil, member: DiscordThreadMember? = nil, defaultAutoArchiveDuration: Int? = nil, permissions: String? = nil, flags: Flags? = nil, totalMessageSent: Int? = nil, availableTags: [DiscordForumTag]? = nil, appliedTags: [String]? = nil, defaultReactionEmoji: DiscordDefaultReaction? = nil, defaultThreadRateLimitPerUser: Int? = nil, defaultSortOrder: Int? = nil, defaultForumLayout: Int? = nil) {
        self.id = id
        self.type = type
        self.guildID = guildID
        self.position = position
        self.permissionOverwrites = permissionOverwrites
        self.name = name
        self.topic = topic
        self.nsfw = nsfw
        self.lastMessageID = lastMessageID
        self.bitrate = bitrate
        self.userLimit = userLimit
        self.rateLimitPerUser = rateLimitPerUser
        self.recipients = recipients
        self.icon = icon
        self.ownerID = ownerID
        self.applicationID = applicationID
        self.managed = managed
        self.parentID = parentID
        self.lastPinTimestamp = lastPinTimestamp
        self.rtcRegion = rtcRegion
        self.videoQualityMode = videoQualityMode
        self.messageCount = messageCount
        self.memberCount = memberCount
        self.threadMetadata = threadMetadata
        self.member = member
        self.defaultAutoArchiveDuration = defaultAutoArchiveDuration
        self.permissions = permissions
        self.flags = flags
        self.totalMessageSent = totalMessageSent
        self.availableTags = availableTags
        self.appliedTags = appliedTags
        self.defaultReactionEmoji = defaultReactionEmoji
        self.defaultThreadRateLimitPerUser = defaultThreadRateLimitPerUser
        self.defaultSortOrder = defaultSortOrder
        self.defaultForumLayout = defaultForumLayout
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case guildID = "guild_id"
        case position
        case permissionOverwrites = "permission_overwrites"
        case name
        case topic
        case nsfw
        case lastMessageID = "last_message_id"
        case bitrate
        case userLimit = "user_limit"
        case rateLimitPerUser = "rate_limit_per_user"
        case recipients
        case icon
        case ownerID = "owner_id"
        case applicationID = "application_id"
        case managed
        case parentID = "parent_id"
        case lastPinTimestamp = "last_pin_timestamp"
        case rtcRegion = "rtc_region"
        case videoQualityMode = "video_quality_mode"
        case messageCount = "message_count"
        case memberCount = "member_count"
        case threadMetadata = "thread_metadata"
        case member
        case defaultAutoArchiveDuration = "default_auto_archive_duration"
        case permissions
        case flags
        case totalMessageSent = "total_message_sent"
        case availableTags = "available_tags"
        case appliedTags = "applied_tags"
        case defaultReactionEmoji = "default_reaction_emoji"
        case defaultThreadRateLimitPerUser = "default_thread_rate_limit_per_user"
        case defaultSortOrder = "default_sort_order"
        case defaultForumLayout = "default_forum_layout"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(ChannelType.self, forKey: .type)
        guildID = try container.decodeIfPresent(String.self, forKey: .guildID)
        position = try container.decodeIfPresent(Int.self, forKey: .position)
        permissionOverwrites = try container.decodeIfPresent([DiscordPermissionOverwrite].self, forKey: .permissionOverwrites)
        name = try container.decodeIfPresent(String?.self, forKey: .name) ?? nil
        topic = try container.decodeIfPresent(String?.self, forKey: .topic) ?? nil
        nsfw = try container.decodeIfPresent(Bool.self, forKey: .nsfw)
        lastMessageID = try container.decodeIfPresent(String?.self, forKey: .lastMessageID) ?? nil
        bitrate = try container.decodeIfPresent(Int.self, forKey: .bitrate)
        userLimit = try container.decodeIfPresent(Int.self, forKey: .userLimit)
        rateLimitPerUser = try container.decodeIfPresent(Int.self, forKey: .rateLimitPerUser)
        recipients = try container.decodeIfPresent([DiscordUser].self, forKey: .recipients)
        icon = try container.decodeIfPresent(String?.self, forKey: .icon) ?? nil
        ownerID = try container.decodeIfPresent(String.self, forKey: .ownerID)
        applicationID = try container.decodeIfPresent(String.self, forKey: .applicationID)
        managed = try container.decodeIfPresent(Bool.self, forKey: .managed)
        parentID = try container.decodeIfPresent(String?.self, forKey: .parentID) ?? nil
        lastPinTimestamp = try container.decodeIfPresent(Date?.self, forKey: .lastPinTimestamp) ?? nil
        rtcRegion = try container.decodeIfPresent(String?.self, forKey: .rtcRegion) ?? nil
        videoQualityMode = try container.decodeIfPresent(Int.self, forKey: .videoQualityMode)
        messageCount = try container.decodeIfPresent(Int.self, forKey: .messageCount)
        memberCount = try container.decodeIfPresent(Int.self, forKey: .memberCount)
        threadMetadata = try container.decodeIfPresent(DiscordThreadMetadata.self, forKey: .threadMetadata)
        member = try container.decodeIfPresent(DiscordThreadMember.self, forKey: .member)
        defaultAutoArchiveDuration = try container.decodeIfPresent(Int.self, forKey: .defaultAutoArchiveDuration)
        permissions = try container.decodeIfPresent(String.self, forKey: .permissions)
        flags = try container.decodeIfPresent(Flags.self, forKey: .flags)
        totalMessageSent = try container.decodeIfPresent(Int.self, forKey: .totalMessageSent)
        availableTags = try container.decodeIfPresent([DiscordForumTag].self, forKey: .availableTags)
        appliedTags = try container.decodeIfPresent([String].self, forKey: .appliedTags)
        defaultReactionEmoji = try container.decodeIfPresent(DiscordDefaultReaction.self, forKey: .defaultReactionEmoji)
        defaultThreadRateLimitPerUser = try container.decodeIfPresent(Int.self, forKey: .defaultThreadRateLimitPerUser)
        defaultSortOrder = try container.decodeIfPresent(Int?.self, forKey: .defaultSortOrder) ?? nil
        defaultForumLayout = try container.decodeIfPresent(Int.self, forKey: .defaultForumLayout)
    }
    
    public struct Mention: Decodable {
        /// id of the channel
        public let id: String
        
        /// id of the guild containing the channel
        public let guildID: String
        
        /// the type of channel
        public let type: ChannelType
        
        /// the name of the channel
        public let name: String
        
        public init(id: String, guildID: String, type: ChannelType, name: String) {
            self.id = id
            self.guildID = guildID
            self.type = type
            self.name = name
        }
        
        private enum CodingKeys: String, CodingKey {
            case id
            case guildID = "guild_id"
            case type
            case name
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(String.self, forKey: .id)
            guildID = try container.decode(String.self, forKey: .guildID)
            type = try container.decode(ChannelType.self, forKey: .type)
            name = try container.decode(String.self, forKey: .name)
        }
    }
    
    public enum ChannelType: Int, Codable {
        case guildText = 0
        case dm = 1
        case guildVoice = 2
        case groupDM = 3
        case guildCategory = 4
        case guildAnnouncement = 5
        case announcementThread = 10
        case publicThread = 11
        case privateThread = 12
        case guildStageVoice = 13
        case guildDirectory = 14
        case guildForum = 15
        case guildMedia = 16
    }
    
    public struct Flags: OptionSet, Decodable {
        public let rawValue: UInt32
        
        public static let pinned = Flags(rawValue: 1 << 1)
        public static let requireTag = Flags(rawValue: 1 << 4)
        public static let hideMediaDownloadOptions = Flags(rawValue: 1 << 15)
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
}
