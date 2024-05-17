import BingoSheetPrintService
import SwiftUI

struct TileView: View {
    let tile: BingoSheetPrintInput.Tile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(tile.id)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .padding(6)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .overlay {
            Text(tile.value)
                .font(.system(size: 24, weight: .bold))
                .minimumScaleFactor(0.5)
                .lineLimit(3)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .frame(width: 100, height: 100)
        .background(tile.isFilled ? Color.pink.opacity(0.15) : .clear)
        .border(Color.black.opacity(0.2))
        .foregroundStyle(.black)
    }
}
