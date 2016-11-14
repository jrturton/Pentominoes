import UIKit

open class TileView: UIView {
    open override class var layerClass : AnyClass {
        return CAShapeLayer.self
    }
    
    fileprivate var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }
    
    let tile: Tile
    fileprivate let gridSize: CGFloat
    
    public init(tile: Tile, color: UIColor = UIColor.white, gridSize: CGFloat = 20.0) {
        self.tile = tile
        self.gridSize = gridSize
        super.init(frame:tile.sizeForGridSize(gridSize))
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.fillColor = color.cgColor
        shapeLayer.path = tilePath()
    }
    
    func randomiseColor() {
        shapeLayer.fillColor = randomColor().cgColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func tilePath() -> CGPath {
        return tile.pathForSquares(true, gridSize: gridSize)
    }
    
    func rotate(_ clockwise: Bool) {
        self.tile.rotate(clockwise)
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(rotationAngle: clockwise ? CGFloat(M_PI_2) : CGFloat(-M_PI_2))
            }, completion: { _ in
                self.transform = CGAffineTransform.identity
                self.shapeLayer.path = self.tilePath()
        })
    }
    
    open var isLifted: Bool = false {
        didSet {
            layer.shadowRadius = 5.0
            layer.shadowOffset = .zero
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = isLifted ? 0.5 : 0.0
        }
    }
}

public func randomColor() -> UIColor {
    return UIColor(hue: CGFloat(arc4random_uniform(255)) / 255, saturation: 1, brightness: 1, alpha: 1)
}
