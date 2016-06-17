//: Playground - noun: a place where people can play
import UIKit
import XCPlayground

public class BoardView: UIView {
    private let board: Board
    public let gridSize: CGFloat
    
    public init(board: Board, gridSize: CGFloat = 20) {
        self.board = board
        self.gridSize = gridSize
        super.init(frame: board.sizeForGridSize(gridSize))
        let gridLayer = CAShapeLayer()
        gridLayer.frame = bounds
        gridLayer.fillColor = UIColor.whiteColor().CGColor
        gridLayer.strokeColor = UIColor.lightGrayColor().CGColor
        layer.addSublayer(gridLayer)
        gridLayer.path = boardPath()
    }
    
    private func boardPath() -> CGPath {
        
        let playableSquares = board.squares().filter { $0.occupied == false }
        let rects : [CGRect] = playableSquares.map { square in
            let originX = CGFloat(square.column) * gridSize
            let originY = CGFloat(square.row) * gridSize
            return CGRect(x: originX, y: originY, width: gridSize, height: gridSize)
        }
        
        let paths : [UIBezierPath] = rects.map {
            return UIBezierPath(rect: $0)
        }
        let path = UIBezierPath()
        paths.forEach { path.appendPath($0) }
        return path.CGPath
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let tileView = TileView(tile: Tile(shape: .X))
let board = Board(size: .SixByTen)
let boardView = BoardView(board: board)
let shapes = (0..<11).map { Shape(rawValue:$0)! }
let tiles = shapes.map { Tile(shape: $0) }
for tile in tiles {
    for square in board.squares() {
        if board.canPositionTile(tile, atSquare: square) {
            board.positionTile(tile, atSquare: square)
            let tileView = TileView(tile: tile,color: randomColor())
            boardView.addSubview(tileView)
            tileView.frame.origin = board.pointAtOriginOfSquare(square, gridSize: boardView.gridSize)
            break
        }
    }
}
boardView

