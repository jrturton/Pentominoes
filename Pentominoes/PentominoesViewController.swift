import UIKit

open class PentominoesViewController: UIViewController {
    
    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet var pan: UIPanGestureRecognizer!
    
    fileprivate let gridSize: CGFloat = 35
    var boardView: BoardView!
    var tileViews: [TileView]!
    open var board: Board! {
        didSet {
            boardView = BoardView(board: board, gridSize: gridSize)
        }
    }
    open var tiles = [Tile]() {
        didSet {
            tileViews = tiles.map { TileView(tile: $0, color: randomColor(), gridSize: gridSize) }
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        print(view)
        view.addSubview(boardView)
        tileViews.forEach { view.addSubview($0) }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        boardView.center = view.center
        positionTiles()
    }
    
    fileprivate func positionTiles() {
        for (index, tileView) in tileViews.enumerated() {
            if tileView.superview != view || tileView == activeTile {
                continue
            }
            switch index {
            case 0...4 :
                tileView.center.x = (view.bounds.width / 6 * CGFloat(index + 1))
                tileView.center.y = tileView.bounds.height
            case 5:
                tileView.center.x = view.bounds.width / 6
                tileView.center.y = view.bounds.midY
            case 6:
                tileView.center.x = view.bounds.width * 0.833333
                tileView.center.y = view.bounds.midY
            default:
                tileView.center.x = (view.bounds.width / 6 * CGFloat(index - 6))
                tileView.center.y = view.bounds.height - tileView.bounds.height
            }
        }
    }
    
    var activeTile: TileView? {
        willSet {
            if let oldActiveTile = activeTile {
                oldActiveTile.lifted = false
                oldActiveTile.layer.zPosition = 0
            }
        }
        didSet {
            boardView.dropPath = activeTile?.tile.pathForSquares(true, gridSize: gridSize)
            if let newActiveTile = activeTile {
                newActiveTile.lifted = true
                newActiveTile.layer.zPosition = 10
                if newActiveTile.superview != view {
                    view.addSubviewPreservingLocation(newActiveTile)
                    board.removeTile(newActiveTile.tile)
                }
            } 
        }
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        activeTile?.rotate(true)
        boardView.dropPath = activeTile?.tile.pathForSquares(true, gridSize: gridSize)
    }
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        
        guard let activeTile = activeTile else { return }
        var fingerClearedLocation = sender.location(in: view)
        fingerClearedLocation.y -= (activeTile.bounds.height ?? 0.0) * 0.5
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.1, animations: { activeTile.center = fingerClearedLocation }) 
        case .changed:
            activeTile.center = fingerClearedLocation
            let locationOnBoard = boardView.convert(activeTile.bounds.origin, from: activeTile)
            if let allowedDropLocation = board.allowedDropLocation(activeTile.tile, atPoint:locationOnBoard, gridSize: gridSize) {
                let squareOrigin = board.pointAtOriginOfSquare(allowedDropLocation, gridSize: gridSize)
                boardView.showDropPathAtOrigin(squareOrigin)
            } else {
                boardView.showDropPathAtOrigin(nil)
            }
        case .ended, .cancelled:
            let locationOnBoard = boardView.convert(activeTile.bounds.origin, from: activeTile)
            let allowedDropLocation = board.allowedDropLocation(activeTile.tile, atPoint:locationOnBoard, gridSize: gridSize)
            
            self.activeTile = nil
            
            if let allowedDropLocation = allowedDropLocation {
                board.positionTile(activeTile.tile, atSquare: allowedDropLocation)
                boardView.addSubviewPreservingLocation(activeTile)
                UIView.animate(withDuration: 0.1, animations: {
                    activeTile.frame.origin = self.board.pointAtOriginOfSquare(allowedDropLocation, gridSize: self.gridSize)
                }) 
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.positionTiles()
                }) 
            }
        default:
            break
        }
    }
}

extension PentominoesViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer != pan {
            return true
        }
        let location = gestureRecognizer.location(in: view)
        if let hitTile = view.hitTest(location, with: nil) as? TileView {
            activeTile = hitTile
            return true
        }
        return false
    }
}
