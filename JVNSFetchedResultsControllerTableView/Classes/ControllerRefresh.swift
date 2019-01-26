struct ControllerRefresh {
    var fetchedResultsBeforeUpdate = 0
    var didInsert = false
    var didDelete = false
    var didUpdate = false
    var didMove = false
    
    /// If true, a new row at the bottom is inserted.
    /// If false, either no rows are inserted, or rows are inserted at the top.
    /// This value is used for auto scrolling.
    var didInsertRowAtBottom = false
    
    func hasOnlyUpdated() -> Bool {
        return !didInsert && !didDelete && didUpdate && !didMove
    }
    
    func didOnlyInsertRowsAtBottom() -> Bool {
        return didInsertRowAtBottom && didInsert && !didDelete && !didUpdate && !didMove
    }
}
