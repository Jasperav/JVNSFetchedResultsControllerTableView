import CoreData
import JVGenericTableView

/// Changes the contentoffsety when a row has changed conditionally. https://stackoverflow.com/questions/54281617/bounce-occurs-when-changing-rows
/// It doesn't animate row changes.
/// This class ensures that the tableview stays in the same position when a new
/// row has inserted, moved or deleted.
open class NSFetchedResultsControllerTableViewAutoScroll<T: UITableViewCell, U: NSFetchRequestResult>: NSFetchedResultsControllerTableView<T, U> {
    
    public override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard !controllerRefresh.didOnlyInsertRowsAtBottom() else {
            autoScrollTableView()
            
            return
        }
        
        // When either the tableView is not scrolled (the user sees the top cell)
        // or only cells are updated, we animate those changes.
        // Else, the tableview gets updated without animation.
        guard tableViewIsScrolled() || controllerRefresh.hasOnlyUpdated() else {
            super.controllerDidChangeContent(controller)
            
            return
        }
        
        // It isn't allowed to combine an insert with any other row change.
        // This is because this class doesn't animate row changes.
        // For only inserts this is correct, but not combined with other row changes.
        assert(!(controllerRefresh.didInsert && !controllerRefresh.didDelete && controllerRefresh.didMove && !controllerRefresh.didUpdate))
        
        let currentSize = self.tableView.contentSize.height
        
        // All those things have to be in the performWithoutAnimations block to omit every weird kinda error.
        UIView.performWithoutAnimation {
            tableView.endUpdates()
            tableView.layoutIfNeeded()
            
            guard tableView.contentSize.height > tableView.bounds.height else {
                // No need to apply content offset since the user sees the whole tableview.
                return
            }
            
            let newSize = tableView.contentSize.height
            
            tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y + newSize - currentSize), animated: false)
        }
    }
    
    /// Auto scrolls the tableview to the most bottom cell if the user is fully seeing the
    /// most bottom cell before the update.
    private func autoScrollTableView() {
        let cellAtBottomRect = tableView.rectForRow(at: IndexPath(row: controllerRefresh.fetchedResultsBeforeUpdate, section: 0))
        let cellAtBottomIsFullyVisible = tableView.bounds.contains(cellAtBottomRect)
        
        tableView.endUpdates()
        
        guard cellAtBottomIsFullyVisible else { return }
        
        tableView.scrollToRow(at: IndexPath(row: resultController.fetchedObjects!.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    private func tableViewIsScrolled() -> Bool {
        return tableView.contentOffset.y != 0
    }
}
