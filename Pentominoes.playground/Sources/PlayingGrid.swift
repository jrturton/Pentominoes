import UIKit

public protocol PlayingGrid : CustomStringConvertible, CustomPlaygroundQuickLookable {
    var rows: [[Bool]] { get }
    subscript(row: Int) -> [Bool] { get }
    func sizeForGridSize(gridSize: CGFloat) -> CGRect
    func pointAtOriginOfSquare(square: Square, gridSize: CGFloat) -> CGPoint
}

extension PlayingGrid {
    public func sizeForGridSize(gridSize: CGFloat) -> CGRect {
        let height = CGFloat(rows.count)
        let width = CGFloat(rows.first?.count ?? 0)
        return CGRect(origin: .zero, size: CGSize(width: gridSize * width, height: gridSize * height))
    }
    
    public func pointAtOriginOfSquare(square: Square, gridSize: CGFloat) -> CGPoint {
        return CGPoint(x: CGFloat(square.column) * gridSize, y: CGFloat(square.row) * gridSize)
    }
}

extension Bool {
    var gridCharacter: String {
        return self ? "#" : "_"
    }
}

extension PlayingGrid where Self: protocol<CustomStringConvertible, CustomPlaygroundQuickLookable> {
    public var description: String {
        let descriptions : [String] = rows.map { row in
            row.reduce("") { string, gridValue in
                string + gridValue.gridCharacter
            }
        }
        return descriptions.joinWithSeparator("\n")
    }
    public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
        return PlaygroundQuickLook(reflecting: description)
    }
}


public struct Square {
    public let row: Int
    public let column: Int
    public let occupied: Bool?
    
    public init(row: Int, column: Int, occupied: Bool? = nil) {
        self.row = row
        self.column = column
        self.occupied = occupied
    }
    
    func offsetBy(square: Square) -> Square {
        return Square(row: self.row + square.row, column: self.column + square.column)
    }
}

public prefix func -(square: Square) -> Square {
    return Square(row: -square.row, column: -square.column)
}

public func ==(left: Square, right: Square) -> Bool {
    return left.row == right.row && left.column == right.column
}

public class GridSquareGenerator: GeneratorType {
    var currentRow: Int = 0
    var currentColumn: Int = -1
    
    let grid: PlayingGrid
    
    public init(grid: PlayingGrid) {
        self.grid = grid
    }
    
    public func next() -> Square? {
        guard currentRow < grid.rows.count else { return nil }
        
        currentColumn += 1
        
        if currentColumn == grid[currentRow].count {
            currentColumn = 0
            currentRow += 1
        }
        if currentRow < grid.rows.count {
            return Square(row: currentRow, column: currentColumn, occupied: grid[currentRow][currentColumn])
        } else {
            return nil
        }
    }
}

public class GridSquareSequence: SequenceType {
    let grid: PlayingGrid
    
    public init(grid: PlayingGrid) {
        self.grid = grid
    }
    
    public func generate() -> GridSquareGenerator {
        return GridSquareGenerator(grid: grid)
    }
}

extension PlayingGrid {
    public func squares() -> GridSquareSequence {
        return GridSquareSequence(grid: self)
    }
    public func occupiedSquares() -> [Square] {
        return squares().filter{ $0.occupied == true }
    }
}


extension PlayingGrid {
    public subscript(row: Int) -> [Bool] {
        get {
            return rows[row]
        }
    }
    
    public func squareWithinGrid(square: Square) -> Bool {
        return square.row >= 0 && square.column >= 0 && square.row < rows.count && square.column < rows[square.row].count
    }
    
    public func squareOccupied(square: Square) -> Bool {
        return self[square.row][square.column]
    }
}

extension PlayingGrid {
    
    public func pathForSquares(occupied: Bool, gridSize: CGFloat) -> CGPath {
        
        let squaresForPath = squares().filter { $0.occupied == occupied }
        
        let rects : [CGRect] = squaresForPath.map { square in
            let originX = CGFloat(square.column) * gridSize
            let originY = CGFloat(square.row) * gridSize
            return CGRect(x: originX, y: originY, width: gridSize, height: gridSize)
        }
        
        let path : UIBezierPath = rects.reduce(UIBezierPath()) { path, rect in
            path.appendPath(UIBezierPath(rect: rect))
            return path
        }
        
        return path.CGPath
    }
}



