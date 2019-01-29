import UIKit
import JVGenericTableView
import JVMiddleTextView
import CoreData

open class NSFetchedResultsControllerViewController<T: UITableViewCell, U: NSFetchRequestResult>: UIViewController {
    
    public let tableView: GenericTableView<T>
    
    private var nsFetchedResultsControllerTableView: NSFetchedResultsControllerTableView<T, U>!
    
    public init(rowHeight: CGFloat, estimatedRowHeight: CGFloat, middleTextView: MiddleTextView, tableViewMode: NSFetchedResultsControllerTableView<T, U>.Mode, configure: @escaping ((_ cell: T, _ result: U) -> ())) {
        tableView = GenericTableView(cellType: T.self, style: .plain, rowHeight: rowHeight, estimatedRowHeight: estimatedRowHeight)
        
        super.init(nibName: nil, bundle: nil)
        
        nsFetchedResultsControllerTableView = NSFetchedResultsControllerTableView(tableView: tableView, view: view, middleTextView: middleTextView, resultController: type(of: self).createResultsController(), mode: tableViewMode, configure: configure)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open class func createResultsController() -> NSFetchedResultsController<U> {
        fatalError()
    }
}
