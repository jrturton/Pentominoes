import UIKit

public protocol PlayingGrid : CustomStringConvertible, CustomPlaygroundQuickLookable {
    var rows: [[Bool]] { get }
    subscript(row: Int) -> [Bool] { get }
    func sizeForGridSize(_ gridSize: CGFloat) -> CGRect
    func pointAtOriginOf(_ square: Square, gridSize: CGFloat) -> CGPoint
    func squareAt(_ point: CGPoint, gridSize: CGFloat) -> Square
}

extension PlayingGrid {
    public func sizeForGridSize(_ gridSize: CGFloat) -> CGRect {
        let height = CGFloat(rows.count)
        let width = CGFloat(rows.first?.count ?? 0)
        return CGRect(origin: .zero, size: CGSize(width: gridSize * width, height: gridSize * height))
    }
    
    public func pointAtOriginOf(_ square: Square, gridSize: CGFloat) -> CGPoint {
        return CGPoint(x: CGFloat(square.column) * gridSize, y: CGFloat(square.row) * gridSize)
    }
    
    public func squareAt(_ point: CGPoint, gridSize: CGFloat) -> Square {
        let row = Int(floor(point.y / gridSize))
        let column = Int(floor(point.x / gridSize))
        return Square(row: row, column: column)
    }
}

extension Bool {
    var gridCharacter: String {
        return self ? "#" : "_"
    }
}

extension PlayingGrid {
    public var description: String {
        let descriptions : [String] = rows.map { row in
            row.reduce("") { string, gridValue in
                string + gridValue.gridCharacter
            }
        }
        return descriptions.joined(separator: "\n")
    }
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
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
    
    func offsetBy(_ square: Square) -> Square {
        return Square(row: self.row + square.row, column: self.column + square.column)
    }
}

public prefix func -(square: Square) -> Square {
    return Square(row: -square.row, column: -square.column)
}

public func ==(left: Square, right: Square) -> Bool {
    return left.row == right.row && left.column == right.column
}

open class GridSquareGenerator: IteratorProtocol {
    var currentRow: Int = 0
    var currentColumn: Int = -1
    
    let grid: PlayingGrid
    
    public init(grid: PlayingGrid) {
        self.grid = grid
    }
    
    open func next() -> Square? {
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

open class GridSquareSequence: Sequence {
    let grid: PlayingGrid
    
    public init(grid: PlayingGrid) {
        self.grid = grid
    }
    
    open func makeIterator() -> GridSquareGenerator {
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
    public func squaresSurrounding(_ square: Square) -> [Square] {
        let firstSurroundingRow = square.row - 1
        let firstSurroundingColumn = square.column - 1
        
        var squares = [Square]()
        for columnAdjust in 0..<3 {
            for rowAdjust in 0..<3 {
                squares.append(Square(row: firstSurroundingRow + rowAdjust, column: firstSurroundingColumn + columnAdjust))
            }
        }
                
        return squares
    }
}


extension PlayingGrid {
    public subscript(row: Int) -> [Bool] {
        get {
            return rows[row]
        }
    }
    
    public func squareWithinGrid(_ square: Square) -> Bool {
        return square.row >= 0 && square.column >= 0 && square.row < rows.count && square.column < rows[square.row].count
    }
    
    public func squareOccupied(_ square: Square) -> Bool {
        return self[square.row][square.column]
    }
}

extension PlayingGrid {
    
    public func pathForSquares(_ occupied: Bool, gridSize: CGFloat) -> CGPath {
        
        let squaresForPath = squares().filter { $0.occupied == occupied }
        
        let rects : [CGRect] = squaresForPath.map { square in
            let originX = CGFloat(square.column) * gridSize
            let originY = CGFloat(square.row) * gridSize
            return CGRect(x: originX, y: originY, width: gridSize, height: gridSize)
        }
        
        let path : UIBezierPath = rects.reduce(UIBezierPath()) { path, rect in
            path.append(UIBezierPath(rect: rect))
            return path
        }
        
        return path.cgPath
    }
}



