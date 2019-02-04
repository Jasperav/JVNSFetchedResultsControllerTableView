import CoreData
import JVGenericTableView
import JVMiddleTextView

open class NSFetchedResultsControllerTableViewLoadable<T: ConfigurableTableViewCell<U>, U: NSFetchRequestResult>: NSFetchedResultsControllerTableView<T, U> {
    
    var loadPositionOffset: NSFetchedResultsControllerTableViewLoadCellOffset?
    internal (set) var mode: NSFetchedResultsControllerTableViewMode

    
    public init(tableView: GenericTableView<T>, view: UIView, middleTextView: MiddleTextView, resultController: NSFetchedResultsController<U>, mode: NSFetchedResultsControllerTableViewMode, loadPositionOffset: LoadCellOffset? = nil, configure: ((_ cell: T, _ result: U) -> ())?) {
        self.mode = mode
        if let loadPositionOffset = loadPositionOffset {
            self.loadPositionOffset = NSFetchedResultsControllerTableViewLoadCellOffset(position: loadPositionOffset.position, offset: loadPositionOffset.offset, scrollView: tableView, reached: loadPositionOffset.reached)
        }
        
        assert(mode == .querying ? loadPositionOffset != nil : true)

        super.init(tableView: tableView, view: view, middleTextView: middleTextView, resultController: resultController, configure: configure)
    }
    
    /// Make sure you call this method after you called super.init.
    open func addOffsetReachedNotification(_ reached: @escaping (() -> ())) {
        loadPositionOffset!.reached = reached
    }
    
    public func receivedData() {
        loadPositionOffset!.receivedData()
    }
    
    public func change(mode: NSFetchedResultsControllerTableViewMode) {
        guard self.mode != mode else { return }
        
        assert(mode == .querying ? loadPositionOffset != nil : true)
        
        self.mode = mode
        let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)
        
        switch mode {
        case .notQuerying:
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .querying:
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func updateMiddleTextView() {
        let hasMinimalOneRow = resultController.fetchedObjects!.count > 0
        
        middleTextViewPresenter.updateMiddleTextView(hasMinimalOneRow: hasMinimalOneRow, mode: mode)
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case .notQuerying:
            return resultController.fetchedObjects!.count
        case .querying:
            return resultController.fetchedObjects!.count + 1
        }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch mode {
        case .notQuerying:
            return createCell(indexPath: indexPath)
        case .querying:
            guard let loadPositionOffset = loadPositionOffset else {
                return createCell(indexPath: indexPath)
            }
            
            switch loadPositionOffset.position {
            case .top:
                if indexPath.row == 0 {
                    return self.tableView.configureLoadCell(indexPath: indexPath)
                } else {
                    let _indexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
                    
                    return createCell(indexPath: _indexPath)
                }
            case .bottom:
                if (indexPath.row + 1) == tableView.numberOfRows(inSection: indexPath.section) {
                    return self.tableView.configureLoadCell(indexPath: indexPath)
                } else {
                    return createCell(indexPath: indexPath)
                }
            }
        }
    }
    
    override func determineAlienCellCount() -> Int {
        switch mode {
        case .notQuerying:
            return 0
        case .querying:
            return 1
        }
    }
}
