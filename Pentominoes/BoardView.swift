import UIKit

open class BoardView: UIView {
    fileprivate let board: Board
    open let gridSize: CGFloat
    
    fileprivate let highlightLayer: CAShapeLayer = {
        $0.anchorPoint = CGPoint(x: 0, y: 0)
        $0.fillColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.25).cgColor
        $0.strokeColor = UIColor.darkGray.cgColor
        $0.lineWidth = 4.0
        $0.isHidden = true
        return $0
    }(CAShapeLayer())
    
    public init(board: Board, gridSize: CGFloat = 20) {
        self.board = board
        self.gridSize = gridSize
        super.init(frame: board.sizeForGridSize(gridSize))
        let gridLayer = CAShapeLayer()
        gridLayer.frame = bounds
        gridLayer.fillColor = UIColor.white.cgColor
        gridLayer.strokeColor = UIColor.lightGray.cgColor
        layer.addSublayer(gridLayer)
        gridLayer.path = boardPath()
        layer.addSublayer(highlightLayer)
    }
    
    fileprivate func boardPath() -> CGPath {
        return board.pathForSquares(false, gridSize: gridSize)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoardView {
    
    var dropPath: CGPath? {
        set {
            let origin = highlightLayer.position
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            highlightLayer.path = newValue
            highlightLayer.position = origin  
            CATransaction.commit()
        }
        get {
            return highlightLayer.path
        }
    }
    
    func showDropPathAtOrigin(_ origin: CGPoint?) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if let origin = origin {
            highlightLayer.position = origin
            highlightLayer.isHidden = false
        } else {
            highlightLayer.isHidden = true
        }
        CATransaction.commit()
    }
}

extension BoardView {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let square = board.squareAtPoint(point, gridSize: gridSize)
        if
            let tile = board.tileAtSquare(square),
            let tileView = (tileViews.filter{ $0.tile.shape == tile.shape }).first {
            return tileView
        }
        
        return super.hitTest(point, with: event)
    }
    
    var tileViews: [TileView] {
        return subviews.filter { $0 is TileView } as! [TileView]
    }
}
