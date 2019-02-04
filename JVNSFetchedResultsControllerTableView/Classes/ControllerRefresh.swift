/// Helper for NSFetchedResultsControllerTableView.
/// Typically reinitialized when controllerWillChangeContent is called.
/// The point of this struct is to help autoscrolling.
struct ControllerRefresh {
    
    /// The NSFetchedResultsController inserted at least one row.
    var didInsert = false
    
    /// The NSFetchedResultsController deleted at least one row.
    var didDelete = false
    
    /// The NSFetchedResultsController updated at least one row.
    var didUpdate = false
    
    /// The NSFetchedResultsController moved at least one row.
    var didMove = false
    
    /// If true, a new row at the bottom is inserted.
    /// If false, either no rows are inserted, or rows are inserted at the top.
    /// This value is used for auto scrolling.
    var didInsertRowAtBottom = true
    
    func hasOnlyUpdated() -> Bool {
        return !didInsert && !didDelete && didUpdate && !didMove
    }
    
    func didOnlyInsertRowsAtBottom() -> Bool {
        return didInsertRowAtBottom && didInsert && !didDelete && !didUpdate && !didMove
    }
}
