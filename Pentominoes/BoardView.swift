import UIKit

public class BoardView: UIView {
    private let board: Board
    public let gridSize: CGFloat
    
    private let highlightLayer: CAShapeLayer = {
        $0.anchorPoint = CGPoint(x: 0, y: 0)
        $0.fillColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.25).CGColor
        $0.strokeColor = UIColor.darkGrayColor().CGColor
        $0.lineWidth = 4.0
        $0.hidden = true
        return $0
    }(CAShapeLayer())
    
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
        layer.addSublayer(highlightLayer)
    }
    
    private func boardPath() -> CGPath {
        return board.pathForSquares(false, gridSize: gridSize)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoardView {
    
    var dropPath: CGPath? {
        set {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            highlightLayer.path = newValue
            CATransaction.commit()
        }
        get {
            return highlightLayer.path
        }
    }
    
    func showDropPathAtOrigin(origin: CGPoint?) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if let origin = origin {
            highlightLayer.position = origin
            highlightLayer.hidden = false
        } else {
            highlightLayer.hidden = true
        }
        CATransaction.commit()
    }
}

extension BoardView {
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        let square = board.squareAtPoint(point, gridSize: gridSize)
        if
            let tile = board.tileAtSquare(square),
            let tileView = (tileViews.filter{ $0.tile.shape == tile.shape }).first {
            return tileView
        }
        
        return super.hitTest(point, withEvent: event)
    }
    
    var tileViews: [TileView] {
        return subviews.filter { $0 is TileView } as! [TileView]
    }
}
