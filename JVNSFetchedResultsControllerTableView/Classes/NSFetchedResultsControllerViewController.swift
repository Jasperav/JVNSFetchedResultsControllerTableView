import UIKit
import JVGenericTableView
import JVMiddleTextView
import CoreData

open class NSFetchedResultsControllerViewController<T: UITableViewCell, U: NSFetchRequestResult, Q: NSFetchedResultsControllerTableView<T, U>>: UIViewController, UITableViewDelegate {
    
    public var tapped: ((U) -> ())!
    public let tableView: GenericTableView<T>
    public internal (set) var nsFetchedResultsControllerTableView: Q!
    
    public init(rowHeight: CGFloat, estimatedRowHeight: CGFloat, middleTextView: MiddleTextView, tableViewMode: NSFetchedResultsControllerTableView<T, U>.Mode, configure: ((_ cell: T, _ result: U) -> ())?, tapped: ((U) -> ())? = nil) {
        tableView = GenericTableView(cellType: T.self, style: .plain, rowHeight: rowHeight, estimatedRowHeight: estimatedRowHeight)
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
}


open class NSFetchedResultsControllerViewControllerAutoScoll<T: ConfigurableTableViewCell<U>, U: NSFetchRequestResult> : NSFetchedResultsControllerViewController<T, U, NSFetchedResultsControllerTableViewAutoScroll<T, U>> {
    public init(rowHeight: CGFloat, estimatedRowHeight: CGFloat, middleTextView: MiddleTextView, tableViewMode: NSFetchedResultsControllerTableView<T, U>.Mode, autoScrollWhenRowsAtBottomAreInserted: Bool, configure: ((_ cell: T, _ result: U) -> ())?, resultController: NSFetchedResultsController<U>? = nil, tapped: ((U) -> ())? = nil) {
        super.init(rowHeight: rowHeight, estimatedRowHeight: estimatedRowHeight, middleTextView: middleTextView, tableViewMode: tableViewMode, configure: configure, tapped: tapped)
        
        nsFetchedResultsControllerTableView = NSFetchedResultsControllerTableViewAutoScroll(tableView: tableView, view: view, middleTextView: middleTextView, resultController: resultController ?? createResultControllerDynamic(), mode: tableViewMode, autoScrollWhenRowsAtBottomAreInserted: autoScrollWhenRowsAtBottomAreInserted, configure: configure)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class NSFetchedResultsControllerViewControllerNonScroll<T: ConfigurableTableViewCell<U>, U: NSFetchRequestResult> : NSFetchedResultsControllerViewController<T, U, NSFetchedResultsControllerTableView<T, U>> {
    
    public init(rowHeight: CGFloat, estimatedRowHeight: CGFloat, middleTextView: MiddleTextView, tableViewMode: NSFetchedResultsControllerTableView<T, U>.Mode, configure: ((_ cell: T, _ result: U) -> ())?, resultController: NSFetchedResultsController<U>? = nil, tapped: ((U) -> ())? = nil) {
        super.init(rowHeight: rowHeight, estimatedRowHeight: estimatedRowHeight, middleTextView: middleTextView, tableViewMode: tableViewMode, configure: configure, tapped: tapped)
        
        nsFetchedResultsControllerTableView = NSFetchedResultsControllerTableView(tableView: tableView, view: view, middleTextView: middleTextView, resultController: resultController ?? createResultControllerDynamic(), mode: tableViewMode, configure: configure)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
