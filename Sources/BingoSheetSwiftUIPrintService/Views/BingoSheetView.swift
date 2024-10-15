import SwiftUI
import BingoSheetPrintService

struct BingoSheetView: View {
    let input: BingoSheetPrintInput
    
    private var angle: Angle {
        .radians(Double((input.playerName + input.gameName).hash) * .pi)
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(input.playerName)
                    .lineLimit(1)
                    .font(.system(size: 32, weight: .bold))
                
                Text(input.gameName)
                    .lineLimit(1)
                    .font(.system(size: 16, weight: .light))
            }
            .foregroundStyle(.white)
            
            Spacer()
            
            Text("👵")
                .font(.system(size: 36))
                .frame(width: 50, height: 50, alignment: .center)
                .background {
                    Circle().fill(.white.opacity(0.2))
                }
        }
        .padding(.horizontal, 24)
    }
    
    var body: some View {
        VStack {
            header
            
            Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                ForEach(0..<input.size, id: \.self) { rowIndex in
                    GridRow {
                        ForEach(0..<input.size, id: \.self) { columnIndex in
                            TileView(tile: input.tiles[Int(rowIndex + columnIndex * input.size)])
                        }
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding(2)
            .border(Color.black.opacity(0.5))
            .background(Color.white)
            .hueRotation(angle)
        }
        .frame(width: 100 * CGFloat(input.size) + 50,
               height: 100 * CGFloat(input.size) + 100)
        .background(Color.pink.hueRotation(angle))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 3)
    }
}

#Preview {
    BingoSheetView(input: .init(gameName: "Test",
                                playerName: "cloclooo",
                                size: 3,
                                tiles: [.init(id: "0", value: "Bob", isFilled: false),
                                        .init(id: "1", value: "Bobilou fait lol wow!!!", isFilled: false),
                                        .init(id: "2", value: "Bob", isFilled: false),
                                        .init(id: "12", value: "Bob", isFilled: false),
                                        .init(id: "4", value: "Allo oulala c'est pas bon non non non", isFilled: false),
                                        .init(id: "5", value: "Bob", isFilled: false),
                                        .init(id: "6", value: "Bob", isFilled: true),
                                        .init(id: "7", value: "Bob", isFilled: true),
                                        .init(id: "10", value: "Bob", isFilled: false)]))
}
