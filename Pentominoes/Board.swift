import CoreGraphics

open class Board: PlayingGrid {
    
    fileprivate (set) open var rows: [[Bool]]
    
    fileprivate let emptyBoard: [[Bool]]
    
    fileprivate struct PlacedTile {
        let square: Square
        let tile: Tile
    }

    fileprivate var placedTiles = [PlacedTile]() {
        didSet {
            updateRows()
        }
    }
    
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
        let paddingHorizontal = [Bool].init(repeating: true, count: 4)
        let paddingVertical = [Bool].init(repeating: true, count: 8 + size.width)
        let fullPaddingVertical = [[Bool]].init(repeating: paddingVertical, count: 4)
        let emptyRow = [Bool].init(repeating: false, count: size.width)
        rows = fullPaddingVertical
        for _ in 0..<size.height {
            rows += [paddingHorizontal + emptyRow + paddingHorizontal]
        }
        rows += fullPaddingVertical
        emptyBoard = rows
    }
}

extension Board {
    
    public func allowedDropLocation(_ tile: Tile, atPoint point: CGPoint, gridSize: CGFloat) -> Square? {
        let potentialSquare = squareAtPoint(point, gridSize: gridSize)
        var allowedDropLocation: Square?
        if canPositionTile(tile, atSquare: potentialSquare) {
            allowedDropLocation = potentialSquare
        } else {
            var distanceToDropPoint = CGFloat.greatestFiniteMagnitude
            for square in squaresSurrounding(potentialSquare) {
                if canPositionTile(tile, atSquare: square) {
                    let origin = pointAtOriginOfSquare(square, gridSize: gridSize)
                    let xDistance = origin.x - point.x
                    let yDistance = origin.y - point.y
                    // No need to sqrt since we're just comparing
                    let distance = (xDistance * xDistance) + (yDistance * yDistance)
                    if distance < distanceToDropPoint {
                        distanceToDropPoint = distance
                        allowedDropLocation = square
                    }
                }
            }
        }
        return allowedDropLocation
    }
    
    public func canPositionTile(_ tile: Tile, atSquare: Square) -> Bool {
        
        for tileSquare in tile.squares() {
            let boardSquare = tileSquare.offsetBy(atSquare)
            if !squareWithinGrid(boardSquare) {
                return false
            }
            if tileSquare.occupied == true && squareOccupied(boardSquare) {
                return false
            }
        }
        return true
    }
    
    public func positionTile(_ tile: Tile, atSquare square: Square) -> Bool {
        if !canPositionTile(tile, atSquare: square) {
            return false
        }
        placedTiles.append(PlacedTile(square: square, tile: tile))
        return true
    }
    
    public func tileAtSquare(_ square: Square) -> Tile? {
        for placedTile in placedTiles {
            let locationInTile = square.offsetBy(-placedTile.square)
            if placedTile.tile.squareWithinGrid(locationInTile) {
                for tileSquare in placedTile.tile.occupiedSquares() {
                    if tileSquare == locationInTile {
                        return placedTile.tile
                    }
                }
            }
        }
        return nil
    }
    
    public func removeTile(_ tile: Tile) -> Tile? {
        if let index = placedTiles.index( where: { $0.tile === tile } ){
            placedTiles.remove(at: index)
            return tile
        }
        return nil
    }
}

extension Board {
    fileprivate func updateRows() {
        rows = emptyBoard
        for placedTile in placedTiles {
            for tileSquare in placedTile.tile.occupiedSquares() {
                let boardLocation = tileSquare.offsetBy(placedTile.square)
                rows[boardLocation.row][boardLocation.column] = true
            }
        }
    }
}
