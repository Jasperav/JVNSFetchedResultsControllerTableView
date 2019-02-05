import JVMiddleTextView
import UIKit
import CoreData

/// Handles the middle view when the table view isn't visible.
/// This presenter class presents two cases:
///  1. Querying status -> Loading indicator with text
///  2. Nothing found -> text
struct MiddleTextViewPresenter {
    
    var isHidden: Bool {
        return middleTextView.isHidden
    }
    
    /// Reference to the view where the tableView and middleTextView are subviews from.
    private unowned let view: UIView
    private unowned let middleTextView: MiddleTextView
    private unowned let tableView: UITableView
    
    init(view: UIView, middleTextView: MiddleTextView, tableView: UITableView) {
        self.view = view
        self.middleTextView = middleTextView
        self.tableView = tableView
        
        
    }
    
    /// Gets called the very first time this view gets presented.
    /// param: hasMinimalOneRow should be filled if the tableView contains at least one configurable cell.
    func setup(hasMinimalOneRow: Bool) {
        assert((tableView.superview! === middleTextView.superview!) && (tableView.superview! === view))
        assert(view.subviews.count == 2)
        
        if hasMinimalOneRow {
            removeMiddleTextView()
        } else {
            middleTextView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    func updateMiddleTextView(hasMinimalOneRow: Bool, mode: NSFetchedResultsControllerTableViewMode) {
        let hasZeroRows = !hasMinimalOneRow
        let middleTextViewIsShown = !middleTextView.isHidden
        
        if middleTextViewIsShown && hasMinimalOneRow {
            removeMiddleTextView()
        } else if middleTextView.isHidden && hasZeroRows {
            showMiddleTextView(mode: mode)
        }
    }
    
    private func showMiddleTextView(mode: NSFetchedResultsControllerTableViewMode) {
        middleTextView.isHidden = false
        tableView.isHidden = true
        
        switch mode {
        case .notQuerying:
            middleTextView.change(mode: .notQuerying)
        case .querying:
            middleTextView.change(mode: .querying)
        }
    }
    
    private func removeMiddleTextView() {
        middleTextView.isHidden = true
        tableView.isHidden = false
    }
}
