import UIKit

public class TileView: UIView {
    public override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    private var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }
    
    private let tile: Tile
    private let gridSize: CGFloat
    
    public init(tile: Tile, color: UIColor = UIColor.whiteColor(), gridSize: CGFloat = 20.0) {
        self.tile = tile
        self.gridSize = gridSize
        super.init(frame:tile.sizeForGridSize(gridSize))
        shapeLayer.strokeColor = UIColor.grayColor().CGColor
        shapeLayer.fillColor = color.CGColor
        shapeLayer.path = tilePath()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func tilePath() -> CGPath {
        let rects : [CGRect] = tile.occupiedSquares().map { square in
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
    
    func rotate(clockwise: Bool) {
        UIView.animateWithDuration(0.4, animations: {
            self.transform = CGAffineTransformMakeRotation(clockwise ? CGFloat(M_PI_2) : CGFloat(-M_PI_2))
            }, completion: { _ in
                self.transform = CGAffineTransformIdentity
                self.tile.rotate(clockwise)
                self.shapeLayer.path = self.tilePath()
        })
    }
    
    public var lifted: Bool = false {
        didSet {
            layer.shadowRadius = 5.0
            layer.shadowOffset = .zero
            layer.shadowColor = UIColor.blackColor().CGColor
            layer.shadowOpacity = lifted ? 0.5 : 0.0
        }
    }
}

public func randomColor() -> UIColor {
    return UIColor(hue: CGFloat(arc4random_uniform(255)) / 255, saturation: 1, brightness: 1, alpha: 1)
}