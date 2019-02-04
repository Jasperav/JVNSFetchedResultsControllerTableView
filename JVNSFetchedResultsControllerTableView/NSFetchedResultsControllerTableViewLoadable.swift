import CoreData
import JVGenericTableView
import JVMiddleTextView

open class NSFetchedResultsControllerTableViewLoadable<T: ConfigurableTableViewCell<U>, U: NSFetchRequestResult>: NSFetchedResultsControllerTableView<T, U> {
    
    private var mode: NSFetchedResultsControllerTableViewMode
    private var loadPositionOffset: NSFetchedResultsControllerTableViewLoadCellOffset?
    
    public init(tableView: GenericTableView<T>, view: UIView, middleTextView: MiddleTextView, resultController: NSFetchedResultsController<U>, mode: NSFetchedResultsControllerTableViewMode, loadPositionOffset: NSFetchedResultsControllerTableViewLoadCellOffset? = nil, configure: ((_ cell: T, _ result: U) -> ())?) {
        self.mode = mode
        self.loadPositionOffset = loadPositionOffset
        
        super.init(tableView: tableView, view: view, middleTextView: middleTextView, resultController: resultController, configure: configure)
    }
    
    public func change(mode: NSFetchedResultsControllerTableViewMode) {
        guard self.mode != mode else { return }
        
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
            if (indexPath.row + 1) == tableView.numberOfRows(inSection: indexPath.section) {
                return self.tableView.configureLoadCell(indexPath: indexPath)
            } else {
                return createCell(indexPath: indexPath)
            }
        }
    }
    
    public func receivedData() {
        loadPositionOffset?.receivedData()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadPositionOffset?.didScroll()
    }
}
