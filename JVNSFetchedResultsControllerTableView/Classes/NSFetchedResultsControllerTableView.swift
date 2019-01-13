import UIKit
import CoreData
import JVMiddleTextView
import JVGenericTableView

open class NSFetchedResultsControllerTableView<T: UITableViewCell, U: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate {
    private unowned let tableView: GenericUITableView<T>
    
    /// Most likely the UIViewController.view property.
    private unowned let nothingFoundViewSuperView: UIView
    
    private let nothingFoundView: NothingFoundView
    private let resultController:  NSFetchedResultsController<U>
    
    /// Should be an unowned reference.
    private let configure: ((_ cell: T, _ result: U) -> ())
    
    public init(tableView: GenericUITableView<T>,
                nothingFoundViewSuperView: UIView,
                nothingFoundView: NothingFoundView,
                resultController: NSFetchedResultsController<U>,
                configure: @escaping ((_ cell: T, _ result: U) -> ())) {
        self.tableView = tableView
        self.nothingFoundViewSuperView = nothingFoundViewSuperView
        self.nothingFoundView = nothingFoundView
        self.resultController = resultController
        self.configure = configure
        
        super.init()
        
        self.resultController.delegate = self
    }
    
    private func showNothingFoundView() {
        guard resultController.fetchedObjects!.count == 0
            && nothingFoundView.superview == nil
            else { return }
        
        nothingFoundView.fill(toSuperview: nothingFoundViewSuperView, toSafeMargins: true)
        tableView.alpha = 0
    }
    
    private func removeNothingFoundView() {
        guard nothingFoundView.superview != nil else { return }
        
        nothingFoundView.removeFromSuperview()
        tableView.alpha = 1
    }
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
            removeNothingFoundView()
        case .delete:
            tableView.deleteRows(at: [newIndexPath!], with: .automatic)
            showNothingFoundView()
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableView.cellIdentifier, for: newIndexPath!) as! T
            let result = resultController.object(at: newIndexPath!)
            
            configure(cell, result)
            
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
