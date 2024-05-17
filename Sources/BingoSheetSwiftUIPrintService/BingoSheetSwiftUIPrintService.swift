import Foundation
import BingoSheetPrintService
import SwiftUI

public struct BingoSheetSwiftUIPrintService: BingoSheetPrintService {
    enum PrintError: Error {
        case noImageRendered
    }
    
    public init() {}
    
    public func print(sheet: BingoSheetPrintInput) async throws -> Data {
        try await Task { @MainActor in
            guard let image = ImageRenderer(content: BingoSheetView(input: sheet)).cgImage else {
                throw PrintError.noImageRendered
            }
            
            let bitmapRep = NSBitmapImageRep(cgImage: image)
            if let data = bitmapRep.representation(using: .jpeg, properties: [:]) {
                return data
            } else {
                throw PrintError.noImageRendered
            }
        }.value
    }
}
