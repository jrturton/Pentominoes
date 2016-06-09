public class Tile: PlayingGrid {
    
    private (set) public var rows: [[Bool]]
    
    public init(shape: Shapes) {
        rows = shape.stringMap.map {
            return $0.characters.map { $0 == "#" }
        }
    }
    
    public func rotate(clockwise: Bool) {
        
        if !clockwise {
            reverseRows()
        }
        rows = transpose(rows)
        if clockwise {
            reverseRows()
        }
    }
    private func reverseRows() {
        rows = rows.map { $0.reverse() }
    }
}

public func transpose<T>(input: [[T]]) -> [[T]] {
    if input.isEmpty { return [[T]]() }
    let count = input[0].count
    var out = [[T]](count: count, repeatedValue: [T]())
    for outer in input {
        for (index, inner) in outer.enumerate() {
            out[index].append(inner)
        }
    }
    
    return out
}

public enum Shapes: Int {
    case O = 0
    case P = 1
    case Q = 2
    case R = 3
    case S = 4
    case T = 5
    case U = 6
    case V = 7
    case W = 8
    case X = 9
    case Y = 10
    case Z = 11
    
    var stringMap: [String] {
        switch self {
        case O:
            return [
                "__#__",
                "__#__",
                "__#__",
                "__#__",
                "__#__"
            ]
        case P:
            return [
                "_____",
                "__##_",
                "__##_",
                "__#__",
                "_____"
            ]
        case Q:
            return [
                "_____",
                "_##__",
                "__#__",
                "__#__",
                "__#__"
            ]
        case R:
            return [
                "_____",
                "__##_",
                "_##__",
                "__#__",
                "_____"
            ]
        case S:
            return [
                "_____",
                "_____",
                "___##",
                "_###_",
                "_____"
            ]
        case T:
            return [
                "_____",
                "_###_",
                "__#__",
                "__#__",
                "_____"
            ]
        case U:
            return [
                "_____",
                "_____",
                "_#_#_",
                "_###_",
                "_____"
            ]
        case V:
            return [
                "_____",
                "_#___",
                "_#___",
                "_###_",
                "_____"
            ]
        case W:
            return [
                "_____",
                "_#___",
                "_##__",
                "__##_",
                "_____"
                
            ]
        case X:
            return [
                "_____",
                "__#__",
                "_###_",
                "__#__",
                "_____"
            ]
        case Y:
            return [
                "_____",
                "__#__",
                "_##__",
                "__#__",
                "__#__"
            ]
        case Z:
            return [
                "_____",
                "_##__",
                "__#__",
                "__##_",
                "_____"
            ]
        }
    }
}
