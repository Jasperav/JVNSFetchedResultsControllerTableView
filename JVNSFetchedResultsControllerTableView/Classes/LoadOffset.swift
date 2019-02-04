import UIKit

public struct LoadCellOffset {
    let reached: (() -> ())!
    let position: NSFetchedResultsControllerTableViewLoadCellPosition
    let offset: CGFloat
    
    public init(position: NSFetchedResultsControllerTableViewLoadCellPosition, offset: CGFloat, reached: (() -> ())? = nil) {
        self.position = position
        self.offset = offset
        self.reached = reached
    }
}

 public struct NSFetchedResultsControllerTableViewLoadCellOffset {
    
    var reached: (() -> ())!
    let position: NSFetchedResultsControllerTableViewLoadCellPosition
    
    private var watch = true
    private let offset: CGFloat
    
    /// I'd rather have this an unowned let than a force unwrapped
    /// weak var. Con: user needs to manually add twice the tableview
    /// or a very long initializer list. An assert is added
    /// to make sure this scrollView always points to the tableView.
    unowned let scrollView: UIScrollView
    
    public init(position: NSFetchedResultsControllerTableViewLoadCellPosition, offset: CGFloat, scrollView: UIScrollView, reached: (() -> ())? = nil) {
        self.position = position
        self.offset = offset
        self.reached = reached
        self.scrollView = scrollView
    }
    
    public mutating func receivedData() {
        watch = false
    }
    
    mutating func didScroll() {
        guard watch, offsetIsReached() else { return }
        
        watch = false
        
        reached()
    }
    
    private func offsetIsReached() -> Bool {
        let currentPosition = scrollView.contentOffset.y

        switch position {
        case .top:
            return offsetTopIsReached(currentPosition: currentPosition)
        case .bottom:
            return offsetBottomIsReached(currentPosition: currentPosition)
        }
    }
    
    private func offsetBottomIsReached(currentPosition: CGFloat) -> Bool {
        let totalHeight = scrollView.contentSize.height - scrollView.bounds.height
        let correctedValue = totalHeight - currentPosition - offset
        
        return correctedValue < 0
    }
    
    private func offsetTopIsReached(currentPosition: CGFloat) -> Bool {
        return currentPosition < offset
    }
}
