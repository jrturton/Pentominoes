//: Playground - noun: a place where people can play

import UIKit



let board = Board(size: .FiveByTwelve)

let tile = Tile(shape: .O)

//tile.rotate(true)
//print("Rotated")

board.positionTile(tile, atSquare: Square(row: 4, column: 6))
board

for square in board.squares() {
    if let tile = board.tileAtSquare(square) {
        print(square)
    }
}

let tile2 = Tile(shape: .P)
board.positionTile(tile2, atSquare: Square(row: 4, column: 8))
board
let tile3 = Tile(shape: .T)
board.removeTile(tile3)
board.removeTile(tile)
board

