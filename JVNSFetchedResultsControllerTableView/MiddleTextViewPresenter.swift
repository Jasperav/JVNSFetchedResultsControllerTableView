import JVMiddleTextView
import UIKit
import CoreData

struct MiddleTextViewPresenter {
    private unowned let view: UIView
    private unowned let middleTextView: MiddleTextView
    private unowned let tableView: UITableView
    
    init(view: UIView, middleTextView: MiddleTextView, tableView: UITableView) {
        self.view = view
        self.middleTextView = middleTextView
        self.tableView = tableView
    }
    
    func setup(hasMinimalOneRow: Bool) {
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
