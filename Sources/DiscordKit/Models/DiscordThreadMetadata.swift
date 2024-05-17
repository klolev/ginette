import Foundation

public struct DiscordThreadMetadata: Decodable {
    /// whether the thread is archived
    public let archived: Bool
    
    /// the thread will stop showing in the channel list after auto_archive_duration minutes of inactivity
    public let autoArchiveDuration: Int
    
    /// timestamp when the thread's archive status was last changed, used for calculating recent activity
    public let archiveTimestamp: Date
    
    /// whether the thread is locked; when a thread is locked, only users with MANAGE_THREADS can unarchive it
    public let locked: Bool
    
    /// whether non-moderators can add other non-moderators to a thread; only available on private threads
    public let invitable: Bool?
    
    /// timestamp when the thread was created; only populated for threads created after 2022-01-09
    public let createTimestamp: Date?
    
    public init(archived: Bool, autoArchiveDuration: Int, archiveTimestamp: Date, locked: Bool, invitable: Bool? = nil, createTimestamp: Date? = nil) {
        self.archived = archived
        self.autoArchiveDuration = autoArchiveDuration
        self.archiveTimestamp = archiveTimestamp
        self.locked = locked
        self.invitable = invitable
        self.createTimestamp = createTimestamp
    }
    
    private enum CodingKeys: String, CodingKey {
        case archived
        case autoArchiveDuration = "auto_archive_duration"
        case archiveTimestamp = "archive_timestamp"
        case locked
        case invitable
        case createTimestamp = "create_timestamp"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        archived = try container.decode(Bool.self, forKey: .archived)
        autoArchiveDuration = try container.decode(Int.self, forKey: .autoArchiveDuration)
        archiveTimestamp = try container.decode(Date.self, forKey: .archiveTimestamp)
        locked = try container.decode(Bool.self, forKey: .locked)
        invitable = try container.decodeIfPresent(Bool.self, forKey: .invitable)
        createTimestamp = try container.decodeIfPresent(Date?.self, forKey: .createTimestamp) ?? nil
    }
}
