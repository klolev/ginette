import Foundation

public struct DiscordPoll: Codable {
    /// The question of the poll. Only text is supported.
    public let question: Media
    
    /// Each of the answers available in the poll.
    public let answers: [Answer]
    
    /// The time when the poll ends.
    public let expiry: Date?
    
    /// Whether a user can select multiple answers
    public let allowMultiselect: Bool
    
    /// The layout type of the poll
    public let layoutType: Int
    
    /// The results of the poll
    public let results: Result?
    
    public init(question: Media, answers: [Answer], expiry: Date? = nil, allowMultiselect: Bool, layoutType: Int, results: Result? = nil) {
        self.question = question
        self.answers = answers
        self.expiry = expiry
        self.allowMultiselect = allowMultiselect
        self.layoutType = layoutType
        self.results = results
    }
    
    private enum CodingKeys: String, CodingKey {
        case question
        case answers
        case expiry
        case allowMultiselect = "allow_multiselect"
        case layoutType = "layout_type"
        case results
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(question, forKey: .question)
        try container.encode(answers, forKey: .answers)
        try container.encodeIfPresent(expiry, forKey: .expiry)
        try container.encode(allowMultiselect, forKey: .allowMultiselect)
        try container.encode(layoutType, forKey: .layoutType)
        try container.encodeIfPresent(results, forKey: .results)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        question = try container.decode(Media.self, forKey: .question)
        answers = try container.decode([Answer].self, forKey: .answers)
        expiry = try container.decodeIfPresent(Date.self, forKey: .expiry)
        allowMultiselect = try container.decode(Bool.self, forKey: .allowMultiselect)
        layoutType = try container.decode(Int.self, forKey: .layoutType)
        results = try container.decodeIfPresent(Result.self, forKey: .results)
    }
    
    public struct Result: Codable {
        /// Whether the votes have been precisely counted
        public let isFinalized: Bool
        
        /// The counts for each answer
        public let answerCounts: [AnswerCount]
        
        public init(isFinalized: Bool, answerCounts: [AnswerCount]) {
            self.isFinalized = isFinalized
            self.answerCounts = answerCounts
        }
        
        private enum CodingKeys: String, CodingKey {
            case isFinalized = "is_finalized"
            case answerCounts = "answer_counts"
        }
        
        public struct AnswerCount: Codable {
            /// The answer_id
            public let id: Int
            
            /// The number of votes for this answer
            public let count: Int
            
            /// Whether the current user voted for this answer
            public let meVoted: Bool
            
            public init(id: Int, count: Int, meVoted: Bool) {
                self.id = id
                self.count = count
                self.meVoted = meVoted
            }
            
            private enum CodingKeys: String, CodingKey {
                case id
                case count
                case meVoted = "me_voted"
            }
        }
    }

    public struct Answer: Codable {
        /// The ID of the answer
        public let answerID: Int
        
        /// The data of the answer
        public let pollMedia: Media
        
        public init(answerID: Int, pollMedia: Media) {
            self.answerID = answerID
            self.pollMedia = pollMedia
        }
        
        private enum CodingKeys: String, CodingKey {
            case answerID = "answer_id"
            case pollMedia = "poll_media"
        }
    }

    public struct Media: Codable {
        /// The text of the field
        public let text: String?
        
        /// The emoji of the field
        public let emoji: DiscordEmoji?
        
        public init(text: String? = nil, emoji: DiscordEmoji? = nil) {
            self.text = text
            self.emoji = emoji
        }
        
        private enum CodingKeys: String, CodingKey {
            case text
            case emoji
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            text = try container.decodeIfPresent(String.self, forKey: .text)
            emoji = try container.decodeIfPresent(DiscordEmoji.self, forKey: .emoji)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(text, forKey: .text)
            try container.encodeIfPresent(emoji, forKey: .emoji)
        }
    }

    public struct Request: Decodable {
        /// The question of the poll. Only text is supported.
        public let question: Media
        
        /// Each of the answers available in the poll, up to 10
        public let answers: [Answer]
        
        /// Number of hours the poll should be open for, up to 7 days
        public let duration: Int
        
        /// Whether a user can select multiple answers
        public let allowMultiselect: Bool
        
        /// The layout type of the poll. Defaults to DEFAULT
        public let layoutType: Int?
        
        public init(question: Media, answers: [Answer], duration: Int, allowMultiselect: Bool, layoutType: Int? = nil) {
            self.question = question
            self.answers = answers
            self.duration = duration
            self.allowMultiselect = allowMultiselect
            self.layoutType = layoutType
        }
        
        private enum CodingKeys: String, CodingKey {
            case question
            case answers
            case duration
            case allowMultiselect = "allow_multiselect"
            case layoutType = "layout_type"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            question = try container.decode(Media.self, forKey: .question)
            answers = try container.decode([Answer].self, forKey: .answers)
            duration = try container.decode(Int.self, forKey: .duration)
            allowMultiselect = try container.decode(Bool.self, forKey: .allowMultiselect)
            layoutType = try container.decodeIfPresent(Int.self, forKey: .layoutType)
        }
    }
}
