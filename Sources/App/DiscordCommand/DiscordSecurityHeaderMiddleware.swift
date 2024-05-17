import Vapor
import DiscordKit

struct DiscordSecurityHeaderMiddleware: AsyncMiddleware {
    let verifier: DiscordSecurityHeaderValidation
    
    init(verifier: DiscordSecurityHeaderValidation) {
        self.verifier = verifier
    }
    
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        guard let signature = request.headers["X-Signature-Ed25519"].first,
              let timestamp = request.headers["X-Signature-Timestamp"].first,
              let data = request.body.data,
              verifier.verify(body: .init(buffer: data, byteTransferStrategy: .automatic),
                              withSignature: signature,
                              andTimestamp: timestamp) else {
            throw Abort(.unauthorized)
        }
        
        return try await next.respond(to: request)
    }
}
