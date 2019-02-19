import UIKit
import JVGenericTableView
import JVMiddleTextView
import CoreData

open class NSFetchedResultsControllerViewController<T: UITableViewCell, U: NSFetchRequestResult, Q: NSFetchedResultsControllerTableView<T, U>>: UIViewController, UITableViewDelegate {
    
    public var tapped: ((U) -> ())!
    public let tableView: GenericTableView<T>
    public internal (set) var nsFetchedResultsControllerTableView: Q!
    
    public init(middleTextView: MiddleTextView, tableViewMode: NSFetchedResultsControllerTableViewMode, configure: ((_ cell: T, _ result: U) -> ())?, tapped: ((U) -> ())? = nil) {
        tableView = GenericTableView(cellType: T.self, style: .plain, rowHeight: T.rowHeight, estimatedRowHeight: T.estimatedRowHeight)
        self.tapped = tapped
        
        super.init(nibName: nil, bundle: nil)
        
        tableView.delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open class func createResultsController() -> NSFetchedResultsController<U> {
        fatalError()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = nsFetchedResultsControllerTableView.getObject(indexPath: indexPath)
        
        tapped!(object)
    }
    
    public func change(sortDescription: NSSortDescriptor) {
        nsFetchedResultsControllerTableView.resultController.fetchRequest.sortDescriptors = [sortDescription]
        
        try! nsFetchedResultsControllerTableView.resultController.performFetch()
        
        tableView.reloadData()
    }
    
    func createResultControllerDynamic() -> NSFetchedResultsController<U> {
        return type(of: self).createResultsController()
    }
    
    // This is needed else it won't be called on the subclasses.
    // This is a bug...
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}


open class NSFetchedResultsControllerViewControllerAutoScoll<T: ConfigurableTableViewCell<U>, U: NSFetchRequestResult>: NSFetchedResultsControllerViewController<T, U, NSFetchedResultsControllerTableViewAutoScroll<T, U>> {
    public init(middleTextView: MiddleTextView, tableViewMode: NSFetchedResultsControllerTableViewMode, autoScrollWhenRowsAtBottomAreInserted: Bool, loadPositionOffset: LoadCellOffset? = nil, configure: ((_ cell: T, _ result: U) -> ())?, resultController: NSFetchedResultsController<U>? = nil, tapped: ((U) -> ())? = nil) {
        super.init(middleTextView: middleTextView, tableViewMode: tableViewMode, configure: configure, tapped: tapped)
        
        nsFetchedResultsControllerTableView = NSFetchedResultsControllerTableViewAutoScroll(tableView: tableView, view: view, middleTextView: middleTextView, resultController: resultController ?? createResultControllerDynamic(), mode: tableViewMode, loadPositionOffset: loadPositionOffset, autoScrollWhenRowsAtBottomAreInserted: autoScrollWhenRowsAtBottomAreInserted, configure: configure)
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
