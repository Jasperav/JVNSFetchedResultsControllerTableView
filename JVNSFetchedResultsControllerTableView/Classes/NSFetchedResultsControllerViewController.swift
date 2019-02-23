import UIKit
import JVGenericTableView
import JVMiddleTextView
import CoreData

open class NSFetchedResultsControllerViewController<T: UITableViewCell, U: NSFetchRequestResult, Q: NSFetchedResultsControllerTableView<T, U>>: UIViewController, UITableViewDelegate {
    
    public var tapped: ((U) -> ())!
    public let tableView: GenericTableView<T>
    public internal (set) var nsFetchedResultsControllerTableView: Q!
    
    public init(middleTextView: MiddleTextView, configure: ((_ cell: T, _ result: U) -> ())?, tapped: ((U) -> ())? = nil) {
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
