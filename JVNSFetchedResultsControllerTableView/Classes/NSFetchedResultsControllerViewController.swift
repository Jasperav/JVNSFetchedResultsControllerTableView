import UIKit
import JVGenericTableView
import JVMiddleTextView
import CoreData

open class NSFetchedResultsControllerViewController<T: UITableViewCell, U: NSFetchRequestResult>: UIViewController, UITableViewDelegate {
    
    public let tableView: GenericTableView<T>
    
    private var nsFetchedResultsControllerTableView: NSFetchedResultsControllerTableView<T, U>!
    
    public var tapped: ((U) -> ())!
    
    public init(rowHeight: CGFloat, estimatedRowHeight: CGFloat, middleTextView: MiddleTextView, tableViewMode: NSFetchedResultsControllerTableView<T, U>.Mode, configure: @escaping ((_ cell: T, _ result: U) -> ()), tapped: ((U) -> ())? = nil) {
        tableView = GenericTableView(cellType: T.self, style: .plain, rowHeight: rowHeight, estimatedRowHeight: estimatedRowHeight)
        self.tapped = tapped
        
        super.init(nibName: nil, bundle: nil)
        
        tableView.delegate = self
        
        nsFetchedResultsControllerTableView = NSFetchedResultsControllerTableView(tableView: tableView, view: view, middleTextView: middleTextView, resultController: type(of: self).createResultsController(), mode: tableViewMode, configure: configure)
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
}
