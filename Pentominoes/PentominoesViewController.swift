import UIKit

open class PentominoesViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet var pan: UIPanGestureRecognizer!
    
    //MARK: - Properties
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
    
    //MARK: - UIViewController
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(boardView)
        tileViews.forEach { view.addSubview($0) }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        boardView.center = view.center
        positionTiles()
    }
    
    //MARK: - Actions
    @IBAction func reset(_ sender: Any) {
        let alert = UIAlertController(title: "Reset", message: "Start again?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            self.resetGame()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func recolour(_ sender: Any) {
        self.tileViews.forEach { $0.randomiseColor() }
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        activeTile?.rotate(true)
        boardView.dropPath = activeTile?.tile.pathForSquares(true, gridSize: gridSize)
    }
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        
        guard let activeTile = activeTile else { return }
        var fingerClearedLocation = sender.location(in: view)
        fingerClearedLocation.y -= activeTile.bounds.height * 0.5
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.1, animations: { activeTile.center = fingerClearedLocation })
        case .changed:
            activeTile.center = fingerClearedLocation
            let locationOnBoard = boardView.convert(activeTile.bounds.origin, from: activeTile)
            if let allowedDropLocation = board.allowedDropLocation(for: activeTile.tile, at:locationOnBoard, gridSize: gridSize) {
                let squareOrigin = board.pointAtOriginOf(allowedDropLocation, gridSize: gridSize)
                boardView.showDropPathAt(squareOrigin)
            } else {
                boardView.showDropPathAt(nil)
            }
        case .ended, .cancelled:
            let locationOnBoard = boardView.convert(activeTile.bounds.origin, from: activeTile)
            let allowedDropLocation = board.allowedDropLocation(for: activeTile.tile, at:locationOnBoard, gridSize: gridSize)
            
            self.activeTile = nil
            
            if let allowedDropLocation = allowedDropLocation {
                let _ = board.position(activeTile.tile, at: allowedDropLocation)
                boardView.addSubviewPreservingLocation(activeTile)
                UIView.animate(withDuration: 0.1, animations: {
                    activeTile.frame.origin = self.board.pointAtOriginOf(allowedDropLocation, gridSize: self.gridSize)
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
    
    //MARK: - Game logic
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
                oldActiveTile.isLifted = false
                oldActiveTile.layer.zPosition = 0
            }
        }
        didSet {
            boardView.dropPath = activeTile?.tile.pathForSquares(true, gridSize: gridSize)
            if let newActiveTile = activeTile {
                newActiveTile.isLifted = true
                newActiveTile.layer.zPosition = 10
                if newActiveTile.superview != view {
                    view.addSubviewPreservingLocation(newActiveTile)
                    let _ = board.remove(newActiveTile.tile)
                }
            }
        }
    }
    
    private func resetGame() {
        for tileView in tileViews {
            if tileView.superview != view {
                view.addSubviewPreservingLocation(tileView)
                let _ = board.remove(tileView.tile)
            }
        }
       
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: -10, options: [], animations: {
            self.positionTiles()
        }, completion: nil)
    }
    
}

//MARK: - Gesture recogniser delegate
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
