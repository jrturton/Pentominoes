public class Board: PlayingGrid {
    
    private (set) public var rows: [[Bool]]
    
    public struct Size {
        let height: Int
        let width: Int
        
        public static let SixByTen = Size(height: 6, width: 10)
        public static let FiveByTwelve = Size(height: 5, width: 12)
        public static let FourByFifteen = Size(height: 4, width: 15)
        public static let ThreeByTwenty = Size(height: 3, width: 20)
    }
    
    public init(size: Size) {
        // Extend by four "occupied" positions in every direction
        let paddingHorizontal = [Bool].init(count: 4, repeatedValue: true)
        let paddingVertical = [Bool].init(count: 8 + size.width, repeatedValue: true)
        let fullPaddingVertical = [[Bool]].init(count: 4, repeatedValue: paddingVertical)
        let emptyRow = [Bool].init(count: size.width, repeatedValue: false)
        rows = fullPaddingVertical
        for _ in 0..<size.height {
            rows += [paddingHorizontal + emptyRow + paddingHorizontal]
        }
        rows += fullPaddingVertical
    }
}

extension Board {
    public func canPositionTile(tile: Tile, atSquare: Square) -> Bool {
        
        for tileSquare in tile.squares() {
            let boardSquare = tileSquare.offsetBy(atSquare)
            if !squareWithinBoard(boardSquare) {
                return false
            }
            if tileSquare.occupied == true && squareOccupied(boardSquare) {
                return false
            }
        }
        return true
    }
}
