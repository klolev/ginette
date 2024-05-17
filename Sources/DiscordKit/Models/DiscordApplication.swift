import Foundation

public struct DiscordApplication: Decodable {
    /// ID of the app
    public let id: String
    
    /// Name of the app
    public let name: String
    
    /// Icon hash of the app
    public let icon: String?
    
    /// Description of the app
    public let description: String
    
    /// List of RPC origin URLs, if RPC is enabled
    public let rpcOrigins: [String]?
    
    /// When false, only the app owner can add the app to guilds
    public let botPublic: Bool
    
    /// When true, the app's bot will only join upon completion of the full OAuth2 code grant flow
    public let botRequireCodeGrant: Bool
    
    /// Partial user object for the bot user associated with the app
    public let bot: DiscordUser?
    
    /// URL of the app's Terms of Service
    public let termsOfServiceURL: String?
    
    /// URL of the app's Privacy Policy
    public let privacyPolicyURL: String?
    
    /// Partial user object for the owner of the app
    public let owner: DiscordUser?
    
    /// deprecated and will be removed in v11. An empty string.
    public let summary: String
    
    /// Hex encoded key for verification in interactions and the GameSDK's GetTicket
    public let verifyKey: String
    
    /// If the app belongs to a team, this will be a list of the members of that team
    public let team: DiscordTeam?
    
    /// Guild associated with the app. For example, a developer support server.
    public let guildID: String?
    
    /// Partial object of the associated guild
    public let guild: DiscordServer?
    
    /// If this app is a game sold on Discord, this field will be the id of the "Game SKU" that is created, if exists
    public let primarySkuID: String?
    
    /// If this app is a game sold on Discord, this field will be the URL slug that links to the store page
    public let slug: String?
    
    /// App's default rich presence invite cover image hash
    public let coverImage: String?
    
    /// App's public flags
    public let flags: Int?
    
    /// Approximate count of guilds the app has been added to
    public let approximateGuildCount: Int?
    
    /// Array of redirect URIs for the app
    public let redirectUris: [String]?
    
    /// Interactions endpoint URL for the app
    public let interactionsEndpointURL: String?
    
    /// Role connection verification URL for the app
    public let roleConnectionsVerificationURL: String?
    
    /// List of tags describing the content and functionality of the app. Max of 5 tags.
    public let tags: [String]?
    
    /// Settings for the app's default in-app authorization link, if enabled
    public let installParams: InstallParams?
    
    /// Default custom authorization URL for the app, if enabled
    public let customInstallURL: String?
    
    public init(id: String, name: String, icon: String? = nil, description: String, rpcOrigins: [String]? = nil, botPublic: Bool, botRequireCodeGrant: Bool, bot: DiscordUser? = nil, termsOfServiceURL: String? = nil, privacyPolicyURL: String? = nil, owner: DiscordUser? = nil, summary: String, verifyKey: String, team: DiscordTeam? = nil, guildID: String? = nil, guild: DiscordServer? = nil, primarySkuID: String? = nil, slug: String? = nil, coverImage: String? = nil, flags: Int? = nil, approximateGuildCount: Int? = nil, redirectUris: [String]? = nil, interactionsEndpointURL: String? = nil, roleConnectionsVerificationURL: String? = nil, tags: [String]? = nil, installParams: InstallParams? = nil, customInstallURL: String? = nil) {
        self.id = id
        self.name = name
        self.icon = icon
        self.description = description
        self.rpcOrigins = rpcOrigins
        self.botPublic = botPublic
        self.botRequireCodeGrant = botRequireCodeGrant
        self.bot = bot
        self.termsOfServiceURL = termsOfServiceURL
        self.privacyPolicyURL = privacyPolicyURL
        self.owner = owner
        self.summary = summary
        self.verifyKey = verifyKey
        self.team = team
        self.guildID = guildID
        self.guild = guild
        self.primarySkuID = primarySkuID
        self.slug = slug
        self.coverImage = coverImage
        self.flags = flags
        self.approximateGuildCount = approximateGuildCount
        self.redirectUris = redirectUris
        self.interactionsEndpointURL = interactionsEndpointURL
        self.roleConnectionsVerificationURL = roleConnectionsVerificationURL
        self.tags = tags
        self.installParams = installParams
        self.customInstallURL = customInstallURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon
        case description
        case rpcOrigins = "rpc_origins"
        case botPublic = "bot_public"
        case botRequireCodeGrant = "bot_require_code_grant"
        case bot
        case termsOfServiceURL = "terms_of_service_url"
        case privacyPolicyURL = "privacy_policy_url"
        case owner
        case summary
        case verifyKey = "verify_key"
        case team
        case guildID = "guild_id"
        case guild
        case primarySkuID = "primary_sku_id"
        case slug
        case coverImage = "cover_image"
        case flags
        case approximateGuildCount = "approximate_guild_count"
        case redirectUris = "redirect_uris"
        case interactionsEndpointURL = "interactions_endpoint_url"
        case roleConnectionsVerificationURL = "role_connections_verification_url"
        case tags
        case installParams = "install_params"
        case customInstallURL = "custom_install_url"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        icon = try container.decodeIfPresent(String?.self, forKey: .icon) ?? nil
        description = try container.decode(String.self, forKey: .description)
        rpcOrigins = try container.decodeIfPresent([String].self, forKey: .rpcOrigins)
        botPublic = try container.decode(Bool.self, forKey: .botPublic)
        botRequireCodeGrant = try container.decode(Bool.self, forKey: .botRequireCodeGrant)
        bot = try container.decodeIfPresent(DiscordUser.self, forKey: .bot)
        termsOfServiceURL = try container.decodeIfPresent(String?.self, forKey: .termsOfServiceURL) ?? nil
        privacyPolicyURL = try container.decodeIfPresent(String?.self, forKey: .privacyPolicyURL) ?? nil
        owner = try container.decodeIfPresent(DiscordUser.self, forKey: .owner)
        summary = try container.decode(String.self, forKey: .summary)
        verifyKey = try container.decode(String.self, forKey: .verifyKey)
        team = try container.decodeIfPresent(DiscordTeam.self, forKey: .team)
        guildID = try container.decodeIfPresent(String?.self, forKey: .guildID) ?? nil
        guild = try container.decodeIfPresent(DiscordServer.self, forKey: .guild)
        primarySkuID = try container.decodeIfPresent(String?.self, forKey: .primarySkuID) ?? nil
        slug = try container.decodeIfPresent(String?.self, forKey: .slug) ?? nil
        coverImage = try container.decodeIfPresent(String?.self, forKey: .coverImage) ?? nil
        flags = try container.decodeIfPresent(Int.self, forKey: .flags)
        approximateGuildCount = try container.decodeIfPresent(Int.self, forKey: .approximateGuildCount)
        redirectUris = try container.decodeIfPresent([String].self, forKey: .redirectUris)
        interactionsEndpointURL = try container.decodeIfPresent(String?.self, forKey: .interactionsEndpointURL) ?? nil
        roleConnectionsVerificationURL = try container.decodeIfPresent(String?.self, forKey: .roleConnectionsVerificationURL) ?? nil
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        installParams = try container.decodeIfPresent(InstallParams.self, forKey: .installParams)
        customInstallURL = try container.decodeIfPresent(String?.self, forKey: .customInstallURL) ?? nil
    }
    
    public struct InstallParams: Decodable {
        /// Scopes to add the application to the server with
        public let scopes: [String]
        
        /// Permissions to request for the bot role
        public let permissions: String
        
        public init(scopes: [String], permissions: String) {
            self.scopes = scopes
            self.permissions = permissions
        }
        
        private enum CodingKeys: String, CodingKey {
            case scopes
            case permissions
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            scopes = try container.decode([String].self, forKey: .scopes)
            permissions = try container.decode(String.self, forKey: .permissions)
        }
    }

    public enum IntegrationType: Int, Codable {
        /// App is installable to servers
        case guildInstall = 0
        /// App is installable to users
        case userInstall = 1
    }
}
