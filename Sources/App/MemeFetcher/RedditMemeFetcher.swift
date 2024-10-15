import Foundation

struct RedditMemeFetcher {
    private let subreddit: String
    
    init(subreddit: String) {
        self.subreddit = subreddit
    }
    
    private var url: URL {
        .init(string: "https://www.reddit.com/r/\(subreddit).json")!
    }
    
    func fetchRandomMeme() async throws -> URL? {
        let data = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data.0) as! [String: Any]
        
        let posts = ((json["data"] as? [String: Any])?["children"] as? [[String: Any]])?
            .compactMap {
                return ($0["data"] as? [String: Any])?["url"] as? String
            }
            .map { URL(string: $0)! }
        
        return posts?.randomElement()
    }
}
