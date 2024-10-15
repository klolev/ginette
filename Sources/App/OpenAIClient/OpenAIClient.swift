import Foundation

struct OpenAIClient {
    private let apiKey: String
    private let assistantKey: String
    
    private static let baseURL: URL = .init(string: "https://api.openai.com/v1")!
    private static let threadsURL: URL = baseURL.appending(path: "threads")
    private static let messagesURL: URL = baseURL.appending(path: "messages")

    init(apiKey: String, assistantKey: String) {
        self.apiKey = apiKey
        self.assistantKey = assistantKey
    }
    
    struct CreateThreadResponse {
        let id: String
        let message: String
    }
    
//    func create(threadWithMessages: [String]) async -> Result<CreateThreadResponse, Error> {
//        
//    }
}
