import Foundation

public struct BingoSheetPrintInput {
    public struct Tile {
        public let id: String
        public let value: String
        public let isFilled: Bool
        
        public init(id: String, value: String, isFilled: Bool) {
            self.id = id
            self.value = value
            self.isFilled = isFilled
        }
    }
    
    public let gameName: String
    public let playerName: String
    public let size: UInt
    public let tiles: [Tile]
    
    public init(gameName: String, playerName: String, size: UInt, tiles: [Tile]) {
        self.gameName = gameName
        self.playerName = playerName
        self.size = size 
        self.tiles = tiles
    }
}

public protocol BingoSheetPrintService {
    func print(sheet: BingoSheetPrintInput) async throws -> Data
}
