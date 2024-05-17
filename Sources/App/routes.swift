import Vapor
import DiscordKit

func routes(_ app: Application) throws {
    
}

public extension AsyncResponseEncodable where Self: Encodable {
    func encodeResponse(for request: Request) async throws -> Response {
        let value = try JSONEncoder().encode(self)
        return .init(headers: ["Content-Type": "application/json"], body: .init(data: value))
    }
}

public extension AsyncRequestDecodable where Self: Decodable {
    static func decodeRequest(_ request: Request) async throws -> Self {
        try request.content.decode(self)
    }
}

extension DiscordInteraction.Response: AsyncResponseEncodable {}
