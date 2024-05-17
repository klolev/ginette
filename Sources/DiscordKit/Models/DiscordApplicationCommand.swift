public struct DiscordApplicationCommand {
    public enum CommandType: Int, Codable {
        /// Slash commands; a text-based command that shows up when a user types /
        case chatInput = 1
        /// A UI-based command that shows up when you right click or tap on a user
        case user = 2
        /// A UI-based command that shows up when you right click or tap on a message
        case message = 3
    }
    
    public struct Create: Encodable {
        /// Name of command, 1-32 characters
        public let name: String
        
        /// Localization dictionary for the name field. Values follow the same restrictions as name
        public let nameLocalizations: [DiscordLocale: String]?
        
        /// 1-100 character description for CHAT_INPUT commands
        public let description: String?
        
        /// Localization dictionary for the description field. Values follow the same restrictions as description
        public let descriptionLocalizations: [DiscordLocale: String]?
        
        /// The parameters for the command
        public let options: [Option]?
        
        /// Set of permissions represented as a bit set
        public let defaultMemberPermissions: String?
        
        /// Deprecated (use contexts instead); Indicates whether the command is available in DMs with the app, only for globally-scoped commands. By default, commands are visible.
        public let dmPermission: Bool?
        
        /// Replaced by default_member_permissions and will be deprecated in the future. Indicates whether the command is enabled by default when the app is added to a guild. Defaults to true
        public let defaultPermission: Bool
        
        /// Installation context(s) where the command is available
        public let integrationTypes: [DiscordApplication.IntegrationType]?
        
        /// Interaction context(s) where the command can be used
        public let contexts: [DiscordInteraction.Request.Context]?
        
        /// Type of command, defaults to 1 if not set
        public let type: CommandType?
        
        /// Indicates whether the command is age-restricted
        public let nsfw: Bool?
        
        public init(name: String, nameLocalizations: [DiscordLocale: String]? = nil, description: String? = nil, descriptionLocalizations: [DiscordLocale: String]? = nil, options: [Option]? = nil, defaultMemberPermissions: String? = nil, dmPermission: Bool? = nil, defaultPermission: Bool = true, integrationTypes: [DiscordApplication.IntegrationType]? = nil, contexts: [DiscordInteraction.Request.Context]? = nil, type: CommandType? = .chatInput, nsfw: Bool? = nil) {
            self.name = name
            self.nameLocalizations = nameLocalizations
            self.description = description
            self.descriptionLocalizations = descriptionLocalizations
            self.options = options
            self.defaultMemberPermissions = defaultMemberPermissions
            self.dmPermission = dmPermission
            self.defaultPermission = defaultPermission
            self.integrationTypes = integrationTypes
            self.contexts = contexts
            self.type = type
            self.nsfw = nsfw
        }
        
        private enum CodingKeys: String, CodingKey {
            case name
            case nameLocalizations = "name_localizations"
            case description
            case descriptionLocalizations = "description_localizations"
            case options
            case defaultMemberPermissions = "default_member_permissions"
            case dmPermission = "dm_permission"
            case defaultPermission = "default_permission"
            case integrationTypes = "integration_types"
            case contexts
            case type
            case nsfw
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(name, forKey: .name)
            try container.encodeIfPresent(nameLocalizations, forKey: .nameLocalizations)
            try container.encodeIfPresent(description, forKey: .description)
            try container.encodeIfPresent(descriptionLocalizations, forKey: .descriptionLocalizations)
            try container.encodeIfPresent(options, forKey: .options)
            try container.encodeIfPresent(defaultMemberPermissions, forKey: .defaultMemberPermissions)
            try container.encodeIfPresent(dmPermission, forKey: .dmPermission)
            try container.encode(defaultPermission, forKey: .defaultPermission)
            try container.encodeIfPresent(integrationTypes, forKey: .integrationTypes)
            try container.encodeIfPresent(contexts, forKey: .contexts)
            try container.encodeIfPresent(type, forKey: .type)
            try container.encodeIfPresent(nsfw, forKey: .nsfw)
        }
        
        public struct Option: Encodable {
            /// Type of option
            public let type: OptionType
            
            /// 1-32 character name
            public let name: String
            
            /// Localization dictionary for the name field. Values follow the same restrictions as name
            public let nameLocalizations: [DiscordLocale: String]?
            
            /// 1-100 character description
            public let description: String
            
            /// Localization dictionary for the description field. Values follow the same restrictions as description
            public let descriptionLocalizations: [DiscordLocale: String]?
            
            /// If the parameter is required or optional--default false
            public let required: Bool?
            
            /// Choices for STRING, INTEGER, and NUMBER types for the user to pick from, max 25
            public let choices: [Choice]?
            
            /// If the option is a subcommand or subcommand group type, these nested options will be the parameters
            public let options: [Option]?
            
            /// If the option is a channel type, the channels shown will be restricted to these types
            public let channelTypes: [DiscordChannel.ChannelType]?
            
            /// If the option is an INTEGER or NUMBER type, the minimum value permitted
            public let minValue: Double?
            
            /// If the option is an INTEGER or NUMBER type, the maximum value permitted
            public let maxValue: Double?
            
            /// For option type STRING, the minimum allowed length (minimum of 0, maximum of 6000)
            public let minLength: Int?
            
            /// For option type STRING, the maximum allowed length (minimum of 1, maximum of 6000)
            public let maxLength: Int?
            
            /// If autocomplete interactions are enabled for this STRING, INTEGER, or NUMBER type option
            public let autocomplete: Bool?
            
            public init(type: OptionType, name: String, nameLocalizations: [DiscordLocale: String]? = nil, description: String, descriptionLocalizations: [DiscordLocale: String]? = nil, required: Bool? = false, choices: [Choice]? = nil, options: [Option]? = nil, channelTypes: [DiscordChannel.ChannelType]? = nil, minValue: Double? = nil, maxValue: Double? = nil, minLength: Int? = nil, maxLength: Int? = nil, autocomplete: Bool? = false) {
                self.type = type
                self.name = name
                self.nameLocalizations = nameLocalizations
                self.description = description
                self.descriptionLocalizations = descriptionLocalizations
                self.required = required
                self.choices = choices
                self.options = options
                self.channelTypes = channelTypes
                self.minValue = minValue
                self.maxValue = maxValue
                self.minLength = minLength
                self.maxLength = maxLength
                self.autocomplete = autocomplete
            }
            
            private enum CodingKeys: String, CodingKey {
                case type
                case name
                case nameLocalizations = "name_localizations"
                case description
                case descriptionLocalizations = "description_localizations"
                case required
                case choices
                case options
                case channelTypes = "channel_types"
                case minValue = "min_value"
                case maxValue = "max_value"
                case minLength = "min_length"
                case maxLength = "max_length"
                case autocomplete
            }
            
            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                
                try container.encode(type, forKey: .type)
                try container.encode(name, forKey: .name)
                try container.encodeIfPresent(nameLocalizations, forKey: .nameLocalizations)
                try container.encode(description, forKey: .description)
                try container.encodeIfPresent(descriptionLocalizations, forKey: .descriptionLocalizations)
                try container.encodeIfPresent(required, forKey: .required)
                try container.encodeIfPresent(choices, forKey: .choices)
                try container.encodeIfPresent(options, forKey: .options)
                try container.encodeIfPresent(channelTypes, forKey: .channelTypes)
                try container.encodeIfPresent(minValue, forKey: .minValue)
                try container.encodeIfPresent(maxValue, forKey: .maxValue)
                try container.encodeIfPresent(minLength, forKey: .minLength)
                try container.encodeIfPresent(maxLength, forKey: .maxLength)
                try container.encodeIfPresent(autocomplete, forKey: .autocomplete)
            }
            
            public enum OptionType: Int, Codable {
                case subCommand = 1
                case subCommandGroup = 2
                case string = 3
                case integer = 4 // Any integer between -2^53 and 2^53
                case boolean = 5
                case user = 6
                case channel = 7 // Includes all channel types + categories
                case role = 8
                case mentionable = 9 // Includes users and roles
                case number = 10 // Any double between -2^53 and 2^53
                case attachment = 11
            }

            public struct Choice: Encodable {
                /// 1-100 character choice name
                public let name: String
                
                /// Localization dictionary for the name field. Values follow the same restrictions as name
                public let nameLocalizations: [DiscordLocale: String]?
                
                /// Value for the choice, up to 100 characters if string
                public let value: Value
                
                public init(name: String, nameLocalizations: [DiscordLocale: String]? = nil, value: Value) {
                    self.name = name
                    self.nameLocalizations = nameLocalizations
                    self.value = value
                }
                
                private enum CodingKeys: String, CodingKey {
                    case name
                    case nameLocalizations = "name_localizations"
                    case value
                }
                
                public func encode(to encoder: any Encoder) throws {
                    var container = encoder.container(keyedBy: CodingKeys.self)
                    
                    try container.encode(name, forKey: .name)
                    try container.encodeIfPresent(nameLocalizations, forKey: .nameLocalizations)
                    try container.encode(value, forKey: .value)
                }
                
                public enum Value: Encodable {
                    case string(String)
                    case integer(Int)
                    case double(Double)
                    
                    public func encode(to encoder: any Encoder) throws {
                        var container = encoder.singleValueContainer()
                        switch self {
                        case .string(let string):
                            try container.encode(string)
                        case .integer(let int):
                            try container.encode(int)
                        case .double(let double):
                            try container.encode(double)
                        }
                    }
                }
            }
        }
    }
}
