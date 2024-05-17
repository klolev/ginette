import Vapor
import DiscordKit

func routes(_ app: Application) throws {
    app.group(DiscordSecurityHeaderMiddleware(verifier: .init(publicKey: Environment.process.PUBLIC_KEY!))) {
        $0.post("interactions") { req async throws -> Response in
            let content = try req.content.decode(DiscordInteraction.Request.self, as: .json)
            let handler = DiscordCommandController(handlers: [DiscordGoCommandController(),
                                                              DiscordPingCommandController(),
                                                              DiscordJoinCommandController(),
                                                              DiscordTilesCommandController(),
                                                              DiscordFillCommandController(),
                                                              DiscordTrashCommandController()])
            let response = try await handler.on(interaction: content, request: req)
            
            switch response {
            case .success(let success):
                let body = try success.map { Response.Body(data: try JSONEncoder().encode($0)) } ?? .empty
                return .init(headers: ["Content-Type": "application/json"],
                             body: body)
            case .failure(let error):
                throw error
            case nil:
                return .init()
            }
        }
    }
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
