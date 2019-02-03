import UIKit

public enum NSFetchedResultsControllerTableViewMode {
    case notQuerying, querying
}

public enum NSFetchedResultsControllerTableViewLoadCellPosition {
    case top, bottom
}

public struct NSFetchedResultsControllerTableViewLoadCellOffset {

    private var watch = false
    private let position: NSFetchedResultsControllerTableViewLoadCellPosition
    private let offset: CGFloat
    private let reached: (() -> ())
    
    /// I'd rather have this an unowned let than a force unwrapped
    /// weak var. Con: user needs to manually add twice the tableview
    /// or a very long initializer list. An assert is added
    /// to make sure this scrollView always points to the tableView.
    unowned let scrollView: UIScrollView
    
    public init(position: NSFetchedResultsControllerTableViewLoadCellPosition, offset: CGFloat, scrollView: UIScrollView, reached: @escaping (() -> ())) {
        self.position = position
        self.offset = offset
        self.reached = reached
        self.scrollView = scrollView
    }
    
    public mutating func receivedData() {
        watch = false
    }
    
    mutating func didScroll() {
        guard watch else { return }
        
        guard offsetIsReached() else { return }
        
        watch = false
        
        reached()
    }
    
    private func offsetIsReached() -> Bool {
        let totalHeight = scrollView.contentSize.height - scrollView.bounds.height
        let currentPosition = scrollView.contentOffset.y
        let correctedValue = totalHeight - currentPosition - offset
        
        // This even works?! :P
        if position == .bottom {
            return correctedValue < 0
        } else {
            return correctedValue > 0
        }
    }
}
