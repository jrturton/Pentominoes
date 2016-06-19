import UIKit

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
        return board.pathForSquares(false, gridSize: gridSize)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
