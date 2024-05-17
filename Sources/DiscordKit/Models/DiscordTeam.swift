import Foundation

public struct DiscordTeam: Decodable {
    /// Hash of the image of the team's icon
    public let icon: String?
    
    /// Unique ID of the team
    public let id: String
    
    /// Members of the team
    public let members: [Member]
    
    /// Name of the team
    public let name: String
    
    /// User ID of the current team owner
    public let ownerUserID: String
    
    public init(icon: String? = nil, id: String, members: [Member], name: String, ownerUserID: String) {
        self.icon = icon
        self.id = id
        self.members = members
        self.name = name
        self.ownerUserID = ownerUserID
    }
    
    private enum CodingKeys: String, CodingKey {
        case icon
        case id
        case members
        case name
        case ownerUserID = "owner_user_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        icon = try container.decodeIfPresent(String?.self, forKey: .icon) ?? nil
        id = try container.decode(String.self, forKey: .id)
        members = try container.decode([Member].self, forKey: .members)
        name = try container.decode(String.self, forKey: .name)
        ownerUserID = try container.decode(String.self, forKey: .ownerUserID)
    }
    
    public struct Member: Decodable {
        /// User's membership state on the team
        public let membershipState: Int
        
        /// ID of the parent team of which they are a member
        public let teamID: String
        
        /// Avatar, discriminator, ID, and username of the user
        public let user: DiscordUser
        
        /// Role of the team member
        public let role: String
        
        public init(membershipState: Int, teamID: String, user: DiscordUser, role: String) {
            self.membershipState = membershipState
            self.teamID = teamID
            self.user = user
            self.role = role
        }
        
        private enum CodingKeys: String, CodingKey {
            case membershipState = "membership_state"
            case teamID = "team_id"
            case user
            case role
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            membershipState = try container.decode(Int.self, forKey: .membershipState)
            teamID = try container.decode(String.self, forKey: .teamID)
            user = try container.decode(DiscordUser.self, forKey: .user)
            role = try container.decode(String.self, forKey: .role)
        }
    }

}
