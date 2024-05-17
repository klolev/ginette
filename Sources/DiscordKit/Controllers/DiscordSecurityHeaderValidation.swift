import Foundation
import CryptoKit

public struct DiscordSecurityHeaderValidation: Sendable {
    private let publicKey: String
    
    public init(publicKey: String) {
        self.publicKey = publicKey
    }
    
    public func verify(body: Data, withSignature signature: String, andTimestamp timestamp: String) -> Bool {
        guard let keyData = Data(hex: publicKey),
              let key = try? P256.Signing.PublicKey(rawRepresentation: keyData),
              let signatureData = Data(hex: signature),
              let signature = try? P256.Signing.ECDSASignature(rawRepresentation: signatureData),
              let timestampData = timestamp.data(using: .utf8) else {
            return false
        }
        
        return key.isValidSignature(signature, for: timestampData + body)
    }
}
