import Foundation

public struct DiscordInteraction {
    public struct Response: Encodable {
        /// The type of response
        public let type: InteractionType
        
        /// An optional response message
        public let data: Data?
        
        public init(type: InteractionType, data: Data? = nil) {
            self.type = type
            self.data = data
        }
        
        private enum CodingKeys: String, CodingKey {
            case type
            case data
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type.rawValue, forKey: .type)
            try container.encodeIfPresent(data, forKey: .data)
        }
        
        public enum InteractionType: Int, Encodable {
            /// ACK a Ping
            case pong = 1
            /// Respond to an interaction with a message
            case channelMessageWithSource = 4
            /// ACK an interaction and edit a response later, the user sees a loading state
            case deferredChannelMessageWithSource = 5
            /// For components, ACK an interaction and edit the original message later; the user does not see a loading state
            case deferredUpdateMessage = 6
            /// For components, edit the message the component was attached to
            case updateMessage = 7
            /// Respond to an autocomplete interaction with suggested choices
            case applicationCommandAutocompleteResult = 8
            /// Respond to an interaction with a popup modal
            case modal = 9
            /// Respond to an interaction with an upgrade button, only available for apps with monetization enabled
            case premiumRequired = 10
        }
        
        public struct Data: Encodable {
            /// is the response TTS
            public let tts: Bool?
            
            /// message content
            public let content: String?
            
            /// supports up to 10 embeds
            public let embeds: [DiscordMessage.Embed]?
            
            /// allowed mentions object
            public let allowedMentions: AllowedMentions?
            
            /// message flags combined as a bitfield (only SUPPRESS_EMBEDS, EPHEMERAL, and SUPPRESS_NOTIFICATIONS can be set)
            public let flags: Int?
            
            /// message components
            public let components: [DiscordMessage.Component]?
            
            /// attachment objects with filename and description
            public let attachments: [DiscordMessage.Attachment]?
            
            /// A poll
            public let poll: DiscordPoll?
            
            public init(tts: Bool? = nil, content: String? = nil, embeds: [DiscordMessage.Embed]? = nil, allowedMentions: AllowedMentions? = nil, flags: Int? = nil, components: [DiscordMessage.Component]? = nil, attachments: [DiscordMessage.Attachment]? = nil, poll: DiscordPoll? = nil) {
                self.tts = tts
                self.content = content
                self.embeds = embeds
                self.allowedMentions = allowedMentions
                self.flags = flags
                self.components = components
                self.attachments = attachments
                self.poll = poll
            }
            
            private enum CodingKeys: String, CodingKey {
                case tts
                case content
                case embeds
                case allowedMentions = "allowed_mentions"
                case flags
                case components
                case attachments
                case poll
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                
                try container.encodeIfPresent(tts, forKey: .tts)
                try container.encodeIfPresent(content, forKey: .content)
                try container.encodeIfPresent(embeds, forKey: .embeds)
                try container.encodeIfPresent(allowedMentions, forKey: .allowedMentions)
                try container.encodeIfPresent(flags, forKey: .flags)
                try container.encodeIfPresent(components, forKey: .components)
                try container.encodeIfPresent(attachments, forKey: .attachments)
                try container.encodeIfPresent(poll, forKey: .poll)
            }
            
            public enum AllowedMentions: String, Encodable {
                /// Controls role mentions
                case roles = "roles"
                /// Controls user mentions
                case users = "users"
                /// Controls @everyone and @here mentions
                case everyone = "everyone"
            }
        }
    }
    
    public struct Request: Decodable {
        /// ID of the interaction
        public let id: String
        
        /// ID of the application this interaction is for
        public let applicationID: String
        
        /// Type of interaction
        public let type: InteractionType
        
        /// Interaction data payload
        public let data: InteractionData
        
        /// Guild that the interaction was sent from
        public let guildID: String?
        
        /// Channel that the interaction was sent from
        public let channel: DiscordChannel?
        
        /// Channel that the interaction was sent from
        public let channelID: String?
        
        /// Guild member data for the invoking user, including permissions
        public let member: DiscordMember?
        
        /// User object for the invoking user, if invoked in a DM
        public let user: DiscordUser?
        
        /// Continuation token for responding to the interaction
        public let token: String
        
        /// Read-only property, always 1
        public let version: Int
        
        /// For components, the message they were attached to
        public let message: DiscordMessage?
        
        /// Bitwise set of permissions the app has in the source location of the interaction
        public let appPermissions: String?
        
        /// Selected language of the invoking user
        public let locale: String?
        
        /// Guild's preferred locale, if invoked in a guild
        public let guildLocale: String?
        
        /// For monetized apps, any entitlements for the invoking user, representing access to premium SKUs
        public let entitlements: [DiscordEntitlement]
        
        /// Mapping of installation contexts that the interaction was authorized for to related user or guild IDs
        public let authorizingIntegrationOwners: [String: [String]]?
        
        /// Context where the interaction was triggered from
        public let context: Context?
        
        public init(id: String, applicationID: String, type: InteractionType, data: InteractionData, guildID: String? = nil, channel: DiscordChannel? = nil, channelID: String? = nil, member: DiscordMember? = nil, user: DiscordUser? = nil, token: String, version: Int, message: DiscordMessage? = nil, appPermissions: String? = nil, locale: String? = nil, guildLocale: String? = nil, entitlements: [DiscordEntitlement], authorizingIntegrationOwners: [String: [String]]? = nil, context: Context? = nil) {
            self.id = id
            self.applicationID = applicationID
            self.type = type
            self.data = data
            self.guildID = guildID
            self.channel = channel
            self.channelID = channelID
            self.member = member
            self.user = user
            self.token = token
            self.version = version
            self.message = message
            self.appPermissions = appPermissions
            self.locale = locale
            self.guildLocale = guildLocale
            self.entitlements = entitlements
            self.authorizingIntegrationOwners = authorizingIntegrationOwners
            self.context = context
        }
        
        private enum CodingKeys: String, CodingKey {
            case id
            case applicationID = "application_id"
            case type
            case data
            case guildID = "guild_id"
            case channel
            case channelID = "channel_id"
            case member
            case user
            case token
            case version
            case message
            case appPermissions = "app_permissions"
            case locale
            case guildLocale = "guild_locale"
            case entitlements
            case authorizingIntegrationOwners = "authorizing_integration_owners"
            case context
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(String.self, forKey: .id)
            applicationID = try container.decode(String.self, forKey: .applicationID)
            type = try container.decode(InteractionType.self, forKey: .type)
            
            switch type {
            case .ping:
                data = .ping
            case .applicationCommand:
                data = .applicationCommand(try container.decode(InteractionData.ApplicationCommandData.self,
                                                                forKey: .data))
            case .messageComponent:
                data = .messageComponent(try container.decode(InteractionData.MessageComponentData.self,
                                                              forKey: .data))
            case .applicationCommandAutocomplete:
                data = .applicationCommandAutocomplete
            case .modalSubmit:
                data = .modalSubmit(try container.decode(InteractionData.ModalData.self, forKey: .data))
            }
            
            guildID = try container.decodeIfPresent(String.self, forKey: .guildID)
            channel = try container.decodeIfPresent(DiscordChannel.self, forKey: .channel)
            channelID = try container.decodeIfPresent(String.self, forKey: .channelID)
            member = try container.decodeIfPresent(DiscordMember.self, forKey: .member)
            user = try container.decodeIfPresent(DiscordUser.self, forKey: .user)
            token = try container.decode(String.self, forKey: .token)
            version = try container.decode(Int.self, forKey: .version)
            message = try container.decodeIfPresent(DiscordMessage.self, forKey: .message)
            appPermissions = try container.decodeIfPresent(String.self, forKey: .appPermissions)
            locale = try container.decodeIfPresent(String.self, forKey: .locale)
            guildLocale = try container.decodeIfPresent(String.self, forKey: .guildLocale)
            entitlements = try container.decode([DiscordEntitlement].self, forKey: .entitlements)
            authorizingIntegrationOwners = try container.decodeIfPresent([String: [String]].self, forKey: .authorizingIntegrationOwners)
            context = try container.decodeIfPresent(Context.self, forKey: .context)
        }
        
        public enum Context: Int, Codable {
            case guild = 0
            case botDM = 1
            case privateChannel = 2
        }
        
        public enum InteractionType: Int, Decodable {
            case ping = 1
            case applicationCommand = 2
            case messageComponent = 3
            case applicationCommandAutocomplete = 4
            case modalSubmit = 5
        }
        
        public enum InteractionData {
            case ping
            case applicationCommand(ApplicationCommandData)
            case messageComponent(MessageComponentData)
            case applicationCommandAutocomplete
            case modalSubmit(ModalData)
            
            public struct ModalData: Decodable {
                /// the custom_id of the modal
                public let customID: String
                
                /// the values submitted by the user
                public let components: [Component]
                
                public enum ComponentType: Int, Decodable {
                    case actionRow = 1
                    case textInput = 4
                }
                
                public enum Component: Decodable {
                    case actionRow([Component])
                    case textInput(TextInputValue)
                    
                    enum CodingKeys: String, CodingKey {
                        case components
                        case type
                    }
                    
                    public struct TextInputValue: Decodable {
                        public let customID: String
                        public let value: String
                        
                        enum CodingKeys: String, CodingKey {
                            case customID = "custom_id"
                            case value
                        }
                    }
                    
                    public init(from decoder: any Decoder) throws {
                        let container = try decoder.container(keyedBy: CodingKeys.self)
                        let type = try container.decode(ComponentType.self, forKey: .type)
                        switch type {
                        case .actionRow:
                            self = .actionRow(try container.decode([Component].self, forKey: .components))
                        case .textInput:
                            self = .textInput(try .init(from: decoder))
                        }
                    }
                }
                
                public init(customID: String, components: [Component]) {
                    self.customID = customID
                    self.components = components
                }
                
                private enum CodingKeys: String, CodingKey {
                    case customID = "custom_id"
                    case components
                }
                
                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    
                    customID = try container.decode(String.self, forKey: .customID)
                    components = try container.decode([Component].self, forKey: .components)
                }
            }
            
            public struct MessageComponentData: Decodable {
                /// the custom_id of the component
                public let customID: String
                
                /// the type of the component
                public let componentType: DiscordMessage.ComponentType
                
                /// values the user selected in a select menu component
                public let values: [DiscordMessage.Component.SelectMenu.Option]?
                
                /// resolved entities from selected options
                public let resolved: DiscordResolvedData?
                
                public init(customID: String, componentType: DiscordMessage.ComponentType, values: [DiscordMessage.Component.SelectMenu.Option]? = nil, resolved: DiscordResolvedData? = nil) {
                    self.customID = customID
                    self.componentType = componentType
                    self.values = values
                    self.resolved = resolved
                }
                
                private enum CodingKeys: String, CodingKey {
                    case customID = "custom_id"
                    case componentType = "component_type"
                    case values
                    case resolved
                }
                
                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    
                    customID = try container.decode(String.self, forKey: .customID)
                    componentType = try container.decode(DiscordMessage.ComponentType.self, forKey: .componentType)
                    values = try container.decodeIfPresent([DiscordMessage.Component.SelectMenu.Option].self, forKey: .values)
                    resolved = try container.decodeIfPresent(DiscordResolvedData.self, forKey: .resolved)
                }
            }
            
            public struct ApplicationCommandData: Decodable {
                /// the ID of the invoked command
                public let id: String
                
                /// the name of the invoked command
                public let name: String
                
                /// the type of the invoked command
                public let type: DiscordApplicationCommand.CommandType
                
                /// converted users + roles + channels + attachments
                public let resolved: DiscordResolvedData?
                
                /// the params + values from the user
                public let options: [Option]?
                
                /// the id of the guild the command is registered to
                public let guildID: String?
                
                /// id of the user or message targeted by a user or message command
                public let targetID: String?
                
                public init(id: String, name: String, type: DiscordApplicationCommand.CommandType, resolved: DiscordResolvedData? = nil, options: [Option]? = nil, guildID: String? = nil, targetID: String? = nil) {
                    self.id = id
                    self.name = name
                    self.type = type
                    self.resolved = resolved
                    self.options = options
                    self.guildID = guildID
                    self.targetID = targetID
                }
                
                private enum CodingKeys: String, CodingKey {
                    case id
                    case name
                    case type
                    case resolved
                    case options
                    case guildID = "guild_id"
                    case targetID = "target_id"
                }
                
                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    
                    id = try container.decode(String.self, forKey: .id)
                    name = try container.decode(String.self, forKey: .name)
                    type = try container.decode(DiscordApplicationCommand.CommandType.self, forKey: .type)
                    resolved = try container.decodeIfPresent(DiscordResolvedData.self, forKey: .resolved)
                    options = try container.decodeIfPresent([Option].self, forKey: .options)
                    guildID = try container.decodeIfPresent(String.self, forKey: .guildID)
                    targetID = try container.decodeIfPresent(String.self, forKey: .targetID)
                }
                
                public struct Option: Decodable {
                    /// Name of the parameter
                    public let name: String
                    
                    /// Value of application command option type
                    public let type: DiscordApplicationCommand.Create.Option.OptionType
                    
                    /// Value of the option resulting from user input
                    public let value: Value?
                    
                    /// Present if this option is a group or subcommand
                    public let options: [Option]?
                    
                    /// true if this option is the currently focused option for autocomplete
                    public let focused: Bool?
                    
                    public init(name: String, type: DiscordApplicationCommand.Create.Option.OptionType, value: Value? = nil, options: [Option]? = nil, focused: Bool? = false) {
                        self.name = name
                        self.type = type
                        self.value = value
                        self.options = options
                        self.focused = focused
                    }
                    
                    private enum CodingKeys: String, CodingKey {
                        case name
                        case type
                        case value
                        case options
                        case focused
                    }
                    
                    public init(from decoder: Decoder) throws {
                        let container = try decoder.container(keyedBy: CodingKeys.self)
                        
                        name = try container.decode(String.self, forKey: .name)
                        type = try container.decode(DiscordApplicationCommand.Create.Option.OptionType.self, forKey: .type)
                        value = try container.decodeIfPresent(Value.self, forKey: .value)
                        options = try container.decodeIfPresent([Option].self, forKey: .options)
                        focused = try container.decodeIfPresent(Bool.self, forKey: .focused)
                    }
                    
                    public enum Value: Decodable {
                        case string(String)
                        case integer(Int)
                        case double(Double)
                        case boolean(Bool)
                        
                        public init(from decoder: Decoder) throws {
                            let container = try decoder.singleValueContainer()
                            
                            if let stringValue = try? container.decode(String.self) {
                                self = .string(stringValue)
                            } else if let intValue = try? container.decode(Int.self) {
                                self = .integer(intValue)
                            } else if let doubleValue = try? container.decode(Double.self) {
                                self = .double(doubleValue)
                            } else if let boolValue = try? container.decode(Bool.self) {
                                self = .boolean(boolValue)
                            } else {
                                throw DecodingError.typeMismatch(Value.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value cannot be decoded"))
                            }
                        }
                    }
                }
            }
        }
    }
}
