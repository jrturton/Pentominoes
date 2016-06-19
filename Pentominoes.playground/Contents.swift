//: Playground - noun: a place where people can play
import UIKit
import XCPlayground

let tileView = TileView(tile: Tile(shape: .Z), color:.purpleColor(), gridSize: 30)
tileView.lifted = true
let board = Board(size: .SixByTen)
let boardView = BoardView(board: board, gridSize: 30)
let shapes = (0..<11).map { Shape(rawValue:$0)! }
let tiles = shapes.map { Tile(shape: $0) }
for tile in tiles {
    for square in board.squares() {
        if board.canPositionTile(tile, atSquare: square) {
            board.positionTile(tile, atSquare: square)
            let tileView = TileView(tile: tile,color: randomColor(), gridSize: boardView.gridSize)
            boardView.addSubview(tileView)
            tileView.frame.origin = board.pointAtOriginOfSquare(square, gridSize: boardView.gridSize)
            break
        }
    }
}
boardView

