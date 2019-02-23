import JVMiddleTextView
import CoreData

open class NSFetchedResultsControllerViewControllerAutoScoll<T: ConfigurableTableViewCell<U>, U: NSFetchRequestResult>: NSFetchedResultsControllerViewController<T, U, NSFetchedResultsControllerTableViewAutoScroll<T, U>> {
    public init(middleTextView: MiddleTextView, tableViewMode: NSFetchedResultsControllerTableViewMode, autoScrollWhenRowsAtBottomAreInserted: Bool, loadPositionOffset: LoadCellOffset? = nil, configure: ((_ cell: T, _ result: U) -> ())?, resultController: NSFetchedResultsController<U>? = nil, tapped: ((U) -> ())? = nil) {
        super.init(middleTextView: middleTextView, configure: configure, tapped: tapped)
        
        nsFetchedResultsControllerTableView = NSFetchedResultsControllerTableViewAutoScroll(tableView: tableView, view: view, middleTextView: middleTextView, resultController: resultController ?? createResultControllerDynamic(), mode: tableViewMode, loadPositionOffset: loadPositionOffset, autoScrollWhenRowsAtBottomAreInserted: autoScrollWhenRowsAtBottomAreInserted, configure: configure)
    }
    
    /// Use this when no query is needed to populate the screen
    public convenience init(nothingSavedText: String, configure: ((_ cell: T, _ result: U) -> ())?, resultController: NSFetchedResultsController<U>? = nil, tapped: ((U) -> ())? = nil) {
        self.init(middleTextView: MiddleTextView(notQueryingText: nothingSavedText), tableViewMode: .notQuerying, autoScrollWhenRowsAtBottomAreInserted: false, configure: configure, tapped: tapped)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard nsFetchedResultsControllerTableView.middleTextViewPresenter.isHidden else { return }
        
        switch nsFetchedResultsControllerTableView.mode {
        case .notQuerying:
            break
        case .querying:
            // If this assertion is triggered it means your loading cell is always visible.
            // This should never happen.
            assert((tableView.contentSize.height - nsFetchedResultsControllerTableView.loadPositionOffset!.offset) > 0)
            nsFetchedResultsControllerTableView.loadPositionOffset!.didScroll()
            
            assert(nsFetchedResultsControllerTableView.loadPositionOffset!.reached != nil)
        }
    }
}
