//: Playground - noun: a place where people can play

import UIKit



let board = Board(size: .FiveByTwelve)

let tile = Tile(shape: .O)

for boardSquare in board.squares() {
    if board.canPositionTile(tile, atSquare: boardSquare) {
        print("Can position at \(boardSquare)")
    } 
}

tile.rotate(true)
print("Rotated")

for boardSquare in board.squares() {
    if board.canPositionTile(tile, atSquare: boardSquare) {
        print("Can position at \(boardSquare)")
    }
}






