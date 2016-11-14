open class Tile: PlayingGrid {
    
    fileprivate (set) open var rows: [[Bool]]
    let shape: Shape
    public init(shape: Shape) {
        rows = shape.stringMap.map {
            return $0.characters.map { $0 == "#" }
        }
        self.shape = shape
    }
    
    open func rotate(_ clockwise: Bool) {
        
        if !clockwise {
            reverseRows()
        }
        rows = transpose(rows)
        if clockwise {
            reverseRows()
        }
    }
    fileprivate func reverseRows() {
        rows = rows.map { $0.reversed() }
    }
}

public func transpose<T>(_ input: [[T]]) -> [[T]] {
    if input.isEmpty { return [[T]]() }
    let count = input[0].count
    var out = [[T]](repeating: [T](), count: count)
    for outer in input {
        for (index, inner) in outer.enumerated() {
            out[index].append(inner)
        }
    }
    
    return out
}

public enum Shape: Int {
    case o = 0
    case p = 1
    case q = 2
    case r = 3
    case s = 4
    case t = 5
    case u = 6
    case v = 7
    case w = 8
    case x = 9
    case y = 10
    case z = 11
    
    var stringMap: [String] {
        switch self {
        case .o:
            return [
                "__#__",
                "__#__",
                "__#__",
                "__#__",
                "__#__"
            ]
        case .p:
            return [
                "_____",
                "__##_",
                "__##_",
                "__#__",
                "_____"
            ]
        case .q:
            return [
                "_____",
                "_##__",
                "__#__",
                "__#__",
                "__#__"
            ]
        case .r:
            return [
                "_____",
                "__##_",
                "_##__",
                "__#__",
                "_____"
            ]
        case .s:
            return [
                "_____",
                "_____",
                "___##",
                "_###_",
                "_____"
            ]
        case .t:
            return [
                "_____",
                "_###_",
                "__#__",
                "__#__",
                "_____"
            ]
        case .u:
            return [
                "_____",
                "_____",
                "_#_#_",
                "_###_",
                "_____"
            ]
        case .v:
            return [
                "_____",
                "_#___",
                "_#___",
                "_###_",
                "_____"
            ]
        case .w:
            return [
                "_____",
                "_#___",
                "_##__",
                "__##_",
                "_____"
                
            ]
        case .x:
            return [
                "_____",
                "__#__",
                "_###_",
                "__#__",
                "_____"
            ]
        case .y:
            return [
                "_____",
                "__#__",
                "_##__",
                "__#__",
                "__#__"
            ]
        case .z:
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
